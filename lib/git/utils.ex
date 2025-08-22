defmodule Git.Utils do
  def sort_compare_branches(comparisons) do
    comparisons
    |> Enum.sort_by(
      fn
        {:ok, [{_, ahead}, {_, behind}]} -> {behind, ahead}
        _ -> false
      end,
      :desc
    )
    |> Enum.reverse()
  end

  def sort_contrast_branches(comparisons) do
    comparisons
    |> Enum.sort_by(
      fn
        [{_, ahead}, {_, behind}] -> {behind, ahead}
        _ -> false
      end,
      :desc
    )
    |> Enum.reverse()
  end
end
