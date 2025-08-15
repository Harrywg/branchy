defmodule TestRepos do
  @test_repo_path Path.expand("./test/test_repo")
  @test_repo_path_remote Path.expand("./test/test_repo_remote")

  # git cmds are using shell to stop logging to term during test
  defp cmd(cmd) do
    System.cmd("sh", ["-c", "#{cmd} &> /dev/null"])
  end

  defp new_file(name, content) do
    File.write!(Path.join(@test_repo_path, name), content)
  end

  def get_test_repo do
    {@test_repo_path, @test_repo_path_remote}
  end

  def repo_1 do
    # Simple linear branching with remote: main -> branch-1 -> branch-2

    # Create initial commit
    new_file("readme.txt", "Initial commit")
    cmd("git add .")
    cmd("git commit -m 'Initial commit'")

    # Add remote and push main branch
    cmd("git remote add origin #{@test_repo_path_remote}")
    cmd("git push -u origin main")

    # branch-1
    new_file("feature.txt", "Feature implementation")
    cmd("git checkout -b branch-1")
    cmd("git add .")
    cmd("git commit -m 'Add feature'")

    # Push branch-1 to remote
    cmd("git push -u origin branch-1")

    # branch-2
    new_file("feature2.txt", "Feature implementation")
    cmd("git checkout -b branch-2")
    cmd("git add .")
    cmd("git commit -m 'Add second feature'")

    # Push branch-2 to remote
    cmd("git push -u origin branch-2")
  end

  def repo_2 do
    # Parallel branches from main (no merges)

    # Initial commit
    new_file("main.txt", "Main branch")
    cmd("git add .")
    cmd("git commit -m 'Main commit'")

    # Add remote and push main branch
    cmd("git remote add origin #{@test_repo_path_remote}")
    cmd("git push -u origin main")

    # branch-1
    cmd("git checkout -b branch-1")
    new_file("a.txt", "Feature A")
    cmd("git add .")
    cmd("git commit -m 'Add feature A'")
    cmd("git checkout main")

    # branch-2
    cmd("git checkout -b branch-2")
    new_file("b.txt", "Feature B")
    cmd("git add .")
    cmd("git commit -m 'Add feature B'")
    cmd("git checkout main")

    # branch-3
    cmd("git checkout -b branch-3")
    new_file("fix.txt", "Bug fix")
    cmd("git add .")
    cmd("git commit -m 'Fix bug'")
  end

  def repo_3 do
    # Multiple commits on different branches (ahead/behind scenario)

    # Initial commit
    new_file("start.txt", "Starting point")
    cmd("git add .")
    cmd("git commit -m 'Start'")

    # Add remote and push main branch
    cmd("git remote add origin #{@test_repo_path_remote}")
    cmd("git push -u origin main")

    # branch-1 2 commits
    new_file("a1.txt", "First commit on A")
    cmd("git checkout -b branch-1")
    cmd("git add .")
    cmd("git commit -m 'A commit 1'")
    new_file("a2.txt", "Second commit on A")
    cmd("git add .")
    cmd("git commit -m 'A commit 2'")
    cmd("git push -u origin branch-1")

    # branch-2 with 3 commits from main
    cmd("git checkout main")
    cmd("git checkout -b branch-2")
    new_file("b1.txt", "First commit on B")
    cmd("git add .")
    cmd("git commit -m 'B commit 1'")
    new_file("b2.txt", "Second commit on B")
    cmd("git add .")
    cmd("git commit -m 'B commit 2'")
    new_file("b3.txt", "Third commit on B")
    cmd("git add .")
    cmd("git commit -m 'B commit 3'")
    cmd("git push -u origin branch-2")
  end
end
