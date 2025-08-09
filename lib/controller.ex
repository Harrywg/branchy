defmodule Controller do
  @spec compare() :: :ok
  def compare do
    with :ok <- Git.fetch(),
         {:ok, local_branches} <- Git.get_all_local_branches(),
         {:ok, head} <- Git.get_remote_head(),
         {:ok, comparisons} <- Git.compare_branches_to_head(local_branches, head) do
      Render.compare(head, comparisons)
    else
      {:error, msg} ->
        Render.error(msg)
    end
  end

  @spec contrast() :: :ok
  def contrast do
    with :ok <- Git.fetch(),
         {:ok, local_branches} <- Git.get_all_local_branches(),
         {:ok, comparisons} <- Git.compare_branches_to_remote(local_branches) do
      Render.contrast(comparisons)
    else
      {:error, msg} ->
        Render.error(msg)
    end
  end

  @spec sync() :: :ok
  def sync do
    IO.puts("sync")
    IO.puts("will pull all local branches if no conflict, else log conflict and abort")
  end

  @spec inspect() :: :ok
  def inspect do
    IO.puts("inspect")
    IO.puts("will run a health check on local branches and highlight any branches okay to delete")
  end
end
