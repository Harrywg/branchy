defmodule Controller do
  @spec compare() :: :ok
  def compare do
    with :ok <- Git.fetch(),
         {:ok, local_branches} <- Git.get_all_local_branches(),
         {:ok, head} <- Git.get_remote_head(),
         {:ok, comparisons} <- Git.compare_branches_to_head(local_branches, head) do
      sorted_comparisons = Git.Utils.sort_compare_branches(comparisons)
      Render.compare(head, sorted_comparisons)
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
      sorted_comparisons = Git.Utils.sort_contrast_branches(comparisons)
      Render.contrast(sorted_comparisons)
    else
      {:error, msg} ->
        Render.error(msg)
    end
  end

  @spec inspect() :: :ok
  def inspect do
    with :ok <- Git.fetch(),
         {:ok, local_branches} <- Git.get_all_local_branches(),
         {:ok, comparisons} <- Git.compare_branches_to_remote(local_branches) do
      sorted_comparisons = Git.Utils.filter_inspect_branches(comparisons)
      number_ok_branches = Git.Utils.number_ok_branches(comparisons)
      Render.inspect(sorted_comparisons, number_ok_branches)
    else
      {:error, msg} ->
        Render.error(msg)
    end
  end
end
