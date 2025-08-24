defmodule Git.Utils do
  def sort_compare_branches(comparisons) do
    comparisons
    |> Enum.sort_by(
      fn
        {:ok, [{_, ahead}, {_, behind}]} -> {behind, ahead}
        _ -> {1, 0, 0}
      end,
      :desc
    )
    |> Enum.reverse()
  end

  def sort_contrast_branches(comparisons) do
    comparisons
    |> Enum.sort_by(
      fn
        [{_, ahead}, {_, behind}] -> {0, behind, ahead}
        _ -> {1, 0, 0}
      end,
      :asc
    )
  end

  def filter_inspect_branches(comparisons) do
    comparisons
    |> Enum.sort_by(
      fn
        [{_, ahead}, {_, behind}] -> {0, behind, ahead}
        _ -> {1, 0, 0}
      end,
      :asc
    )
    |> Enum.filter(fn
      [{_, ahead}, {_, behind}] -> ahead == 0 and behind == 0
      _ -> true
    end)
  end

  def number_ok_branches(comparisons) do
    comparisons
    |> Enum.count(fn
      [{_, "0"}, {_, "0"}] -> true
      _ -> false
    end)
  end
end
