defmodule TestRepos do
  def repo_1() do
    # Create branch1 with a file
    System.cmd("git", ["checkout", "-b", "branch1"])
    File.write!("file1.txt", "content for branch1")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add file1 on branch1"])

    # Create branch2 from branch1 with its own file
    System.cmd("git", ["checkout", "-b", "branch2"])
    File.write!("file2.txt", "content for branch2")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add file2 on branch2"])

    # Create branch3 from branch2 with its own file
    System.cmd("git", ["checkout", "-b", "branch3"])
    File.write!("file3.txt", "content for branch3")
    System.cmd("git", ["add", "."])
    System.cmd("git", ["commit", "-m", "Add file3 on branch3"])
  end
end
