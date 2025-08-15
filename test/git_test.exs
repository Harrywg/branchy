defmodule Test.Git do
  use ExUnit.Case
  doctest Branchy

  Code.require_file("test_repos.ex", Path.dirname(__ENV__.file))

  setup do
    {test_repo_path, test_repo_path_remote} = TestRepos.get_test_repo()
    original_dir = File.cwd!()

    # Init test repo
    File.rm_rf!(test_repo_path)
    File.mkdir_p!(test_repo_path)
    System.cmd("git", ["init"], cd: test_repo_path)

    File.rm_rf!(test_repo_path_remote)
    File.mkdir_p!(test_repo_path_remote)
    System.cmd("git", ["init", "--bare"], cd: test_repo_path_remote)

    File.cd(test_repo_path)

    # Restore original working directory on cleanup
    on_exit(fn ->
      File.cd!(original_dir)
      File.rm_rf!(test_repo_path)
      File.rm_rf!(test_repo_path_remote)
    end)

    :ok
  end

  describe "read_terminal_output/1" do
    test "processes simple multi-line output" do
      input = "branch1\nbranch2\nbranch3"
      expected = ["branch1", "branch2", "branch3"]
      assert Git.read_terminal_output(input) == expected
    end

    test "handles empty string" do
      input = ""
      expected = []
      assert Git.read_terminal_output(input) == expected
    end

    test "trims leading and trailing whitespace" do
      input = "  branch1  \n  branch2  \n  branch3  "
      expected = ["branch1", "branch2", "branch3"]
      assert Git.read_terminal_output(input) == expected
    end

    test "filters out empty lines" do
      input = "branch1\n\nbranch2\n\n\nbranch3\n"
      expected = ["branch1", "branch2", "branch3"]
      assert Git.read_terminal_output(input) == expected
    end

    test "filters out lines with only whitespace" do
      input = "branch1\n   \nbranch2\n\t\t\nbranch3\n    \n"
      expected = ["branch1", "branch2", "branch3"]
      assert Git.read_terminal_output(input) == expected
    end

    test "handles git remote show origin output" do
      input = "* remote origin\n  Fetch URL: git@github.com:user/repo.git\n  HEAD branch: main\n"

      expected = [
        "* remote origin",
        "Fetch URL: git@github.com:user/repo.git",
        "HEAD branch: main"
      ]

      assert Git.read_terminal_output(input) == expected
    end
  end

  describe "compare_two_branches/2" do
    test "return error if branches do not exist" do
      TestRepos.repo_1()

      # One real one fake branch
      res_1 = Git.compare_two_branches("branch-1", "fake-branch")
      assert {128, {"branch-1", "fake-branch"}} = res_1

      # Two fake branches
      res_1 = Git.compare_two_branches("fake-branch", "another-fake-branch")
      assert {128, {"fake-branch", "another-fake-branch"}} = res_1
    end

    test "linear branching - branches ahead of each other using repo_1" do
      TestRepos.repo_1()

      # Same branch comparison should show 0 commits ahead for both
      res_1 = Git.compare_two_branches("branch-1", "branch-1")
      assert {:ok, [{"branch-1", "0"}, {"branch-1", "0"}]} = res_1

      # branch-1 is 2 commits ahead of branch-2, branch-2 is 0 commits ahead of branch-1
      res_2 = Git.compare_two_branches("branch-1", "branch-2")
      assert {:ok, [{"branch-1", "0"}, {"branch-2", "1"}]} = res_2

      # main is behind both branches
      res_3 = Git.compare_two_branches("main", "branch-2")
      assert {:ok, [{"main", "0"}, {"branch-2", "2"}]} = res_3
    end

    test "parallel branches from main using repo_2" do
      TestRepos.repo_2()

      # Compare parallel branches - each should be 1 commit ahead of the other
      res_1 = Git.compare_two_branches("branch-1", "branch-2")
      assert {:ok, [{"branch-1", "1"}, {"branch-2", "1"}]} = res_1

      # Compare branch to main - branch should be 1 ahead, main should be 0 ahead
      res_2 = Git.compare_two_branches("branch-1", "main")
      assert {:ok, [{"branch-1", "1"}, {"main", "0"}]} = res_2

      # Compare branch-3 to other branches
      res_3 = Git.compare_two_branches("branch-3", "branch-1")
      assert {:ok, [{"branch-3", "1"}, {"branch-1", "1"}]} = res_3
    end

    test "multiple commits ahead/behind scenario using repo_3" do
      TestRepos.repo_3()

      # branch-1 has 2 commits, branch-2 has 3 commits, both from same base
      res_1 = Git.compare_two_branches("branch-1", "branch-2")
      assert {:ok, [{"branch-1", "2"}, {"branch-2", "3"}]} = res_1

      # Compare branches back to main - they should be ahead by their commit count
      res_2 = Git.compare_two_branches("branch-1", "main")
      assert {:ok, [{"branch-1", "2"}, {"main", "0"}]} = res_2

      res_3 = Git.compare_two_branches("branch-2", "main")
      assert {:ok, [{"branch-2", "3"}, {"main", "0"}]} = res_3
    end
  end

  describe "compare_branches_to_head/2" do
    test "returns error if branches do not exist" do
      TestRepos.repo_1()
      assert {:error, _} = Git.compare_branches_to_head(["fake-branch"], "main")
    end

    test "returns :ok when real branches compared to HEAD" do
      TestRepos.repo_1()
      assert {:ok, _} = Git.compare_branches_to_head(["branch-1", "branch-2"], "main")
    end

    test "returns correct commit counts when real branches compared to HEAD" do
      TestRepos.repo_1()

      assert {:ok,
              [
                [{"branch-1", "1"}, {"origin/main", "0"}],
                [{"branch-2", "2"}, {"origin/main", "0"}]
              ]} =
               Git.compare_branches_to_head(["branch-1", "branch-2"], "main")
    end

    # test "returns correct commit counts for parallel branches in repo_2" do
    #   TestRepos.repo_2()

    #   assert {:ok,
    #           [
    #             [{"branch-1", "1"}, {"origin/main", "0"}]
    #           ]} =
    #            Git.compare_branches_to_head(["branch-1", "branch-2", "branch-3"], "main")
    # end

    # test "returns correct commit counts for branches with multiple commits in repo_3" do
    #   TestRepos.repo_3()

    #   assert {:ok,
    #           [
    #             [{"branch-1", "2"}, {"origin/main", "0"}],
    #             [{"branch-2", "3"}, {"origin/main", "0"}]
    #           ]} =
    #            Git.compare_branches_to_head(["branch-1", "branch-2"], "main")
    # end
  end
end
