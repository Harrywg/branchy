defmodule Test.Git do
  use ExUnit.Case
  doctest Branchy

  Code.require_file("test_repos.ex", Path.dirname(__ENV__.file))
  @test_repo_path "./test/test_repo"

  setup do
    original_dir = File.cwd!()

    # Init test repo
    File.rm_rf!(@test_repo_path)
    File.mkdir_p!(@test_repo_path)
    System.cmd("git", ["init"], cd: @test_repo_path)
    System.cmd("git", ["config", "user.email", "test@example.com"], cd: @test_repo_path)
    System.cmd("git", ["config", "user.name", "Test User"], cd: @test_repo_path)

    File.cd!(@test_repo_path)

    # Restore original working directory
    on_exit(fn ->
      File.cd!(original_dir)
      File.rm_rf!(@test_repo_path)
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
    test "simple comparison with same commits using imported repo_1" do
      TestRepos.repo_1()

      res_2 = Git.compare_two_branches("branch1", "branch1")
      assert {:ok, [{"branch1", "0"}, {"branch1", "0"}]} = res_2

      res_1 = Git.compare_two_branches("branch1", "branch2")
      assert {:ok, [{"branch1", "0"}, {"branch2", "1"}]} = res_1

      res_2 = Git.compare_two_branches("branch1", "branch3")
      assert {:ok, [{"branch1", "0"}, {"branch3", "2"}]} = res_2
    end
  end
end
