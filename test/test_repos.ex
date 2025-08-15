defmodule TestRepos do
  @test_repo_path Path.expand("./test/test_repo")
  @test_repo_path_remote Path.expand("./test/test_repo_remote")

  def get_test_repo do
    {@test_repo_path, @test_repo_path_remote}
  end

  def repo_1 do
    # Simple linear branching with remote: main -> branch-1 -> branch-2

    File.write!(Path.join(@test_repo_path, "readme.txt"), "Initial commit")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Initial commit"], cd: @test_repo_path)

    # Add remote and push main branch
    System.cmd("git", ["remote", "add", "origin", @test_repo_path_remote], cd: @test_repo_path)
    System.cmd("git", ["push", "-u", "origin", "main"], cd: @test_repo_path)

    System.cmd("git", ["checkout", "-b", "branch-1"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "feature.txt"), "Feature implementation")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Add feature"], cd: @test_repo_path)

    # Push branch-1 to remote
    System.cmd("git", ["push", "-u", "origin", "branch-1"], cd: @test_repo_path)

    System.cmd("git", ["checkout", "-b", "branch-2"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "feature2.txt"), "Second feature")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Add second feature"], cd: @test_repo_path)

    # Push branch-2 to remote
    System.cmd("git", ["push", "-u", "origin", "branch-2"], cd: @test_repo_path)
  end

  def repo_2 do
    # Parallel branches from main (no merges)
    File.write!(Path.join(@test_repo_path, "main.txt"), "Main branch")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Main commit"], cd: @test_repo_path)

    System.cmd("git", ["checkout", "-b", "branch-1"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "a.txt"), "Feature A")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Add feature A"], cd: @test_repo_path)

    System.cmd("git", ["checkout", "main"], cd: @test_repo_path)
    System.cmd("git", ["checkout", "-b", "branch-2"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "b.txt"), "Feature B")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Add feature B"], cd: @test_repo_path)

    System.cmd("git", ["checkout", "main"], cd: @test_repo_path)
    System.cmd("git", ["checkout", "-b", "branch-3"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "fix.txt"), "Bug fix")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Fix bug"], cd: @test_repo_path)
  end

  def repo_3 do
    # Multiple commits on different branches (ahead/behind scenario)
    File.write!(Path.join(@test_repo_path, "start.txt"), "Starting point")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "Start"], cd: @test_repo_path)

    # Branch 1 with 2 commits
    System.cmd("git", ["checkout", "-b", "branch-1"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "a1.txt"), "First commit on A")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "A commit 1"], cd: @test_repo_path)

    File.write!(Path.join(@test_repo_path, "a2.txt"), "Second commit on A")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "A commit 2"], cd: @test_repo_path)

    # Branch 2 with 3 commits from main
    System.cmd("git", ["checkout", "main"], cd: @test_repo_path)
    System.cmd("git", ["checkout", "-b", "branch-2"], cd: @test_repo_path)
    File.write!(Path.join(@test_repo_path, "b1.txt"), "First commit on B")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "B commit 1"], cd: @test_repo_path)

    File.write!(Path.join(@test_repo_path, "b2.txt"), "Second commit on B")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "B commit 2"], cd: @test_repo_path)

    File.write!(Path.join(@test_repo_path, "b3.txt"), "Third commit on B")
    System.cmd("git", ["add", "."], cd: @test_repo_path)
    System.cmd("git", ["commit", "-m", "B commit 3"], cd: @test_repo_path)
  end
end
