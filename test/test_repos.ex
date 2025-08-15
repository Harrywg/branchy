defmodule TestRepos do
  def repo_1() do
    # Simple linear branching: main -> branch-1 -> branch-2
    File.write!("readme.txt", "Initial commit")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Initial commit"])

    System.cmd("git", ["checkout", "-b", "branch-1"])
    File.write!("feature.txt", "Feature implementation")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add feature"])

    System.cmd("git", ["checkout", "-b", "branch-2"])
    File.write!("feature2.txt", "Second feature")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add second feature"])
  end

  def repo_2() do
    # Parallel branches from main (no merges)
    File.write!("main.txt", "Main branch")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Main commit"])

    System.cmd("git", ["checkout", "-b", "branch-1"])
    File.write!("a.txt", "Feature A")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add feature A"])

    System.cmd("git", ["checkout", "main"])
    System.cmd("git", ["checkout", "-b", "branch-2"])
    File.write!("b.txt", "Feature B")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add feature B"])

    System.cmd("git", ["checkout", "main"])
    System.cmd("git", ["checkout", "-b", "branch-3"])
    File.write!("fix.txt", "Bug fix")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Fix bug"])
  end

  def repo_3() do
    # Multiple commits on different branches (ahead/behind scenario)
    File.write!("start.txt", "Starting point")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Start"])

    # Branch 1 with 2 commits
    System.cmd("git", ["checkout", "-b", "branch-1"])
    File.write!("a1.txt", "First commit on A")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "A commit 1"])

    File.write!("a2.txt", "Second commit on A")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "A commit 2"])

    # Branch 2 with 3 commits from main
    System.cmd("git", ["checkout", "main"])
    System.cmd("git", ["checkout", "-b", "branch-2"])
    File.write!("b1.txt", "First commit on B")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "B commit 1"])

    File.write!("b2.txt", "Second commit on B")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "B commit 2"])

    File.write!("b3.txt", "Third commit on B")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "B commit 3"])
  end
end
