defmodule Cmd do
  def compare do
    local_branches = Git.get_all_local_branches()
    {:ok, head} = Git.get_remote_head()

    comparison_results =
      Enum.map(local_branches, fn branch ->
        Git.compare_two_branches(branch, "origin/#{head}")
      end)

    Render.compare(head, comparison_results)
  end

  def contrast do
    IO.puts("contrast:")
    IO.puts("will check all local branches against remote counterparts if exists")
  end

  def inspect do
    IO.puts("inspect")

    IO.puts("will run a health check on local branches and highlight any branches okay to delete")
  end
end
