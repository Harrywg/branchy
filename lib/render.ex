defmodule Render do
  def compare(head, comparisons) do
    IO.puts("")
    IO.puts("Local branches compared against #{Style.head_branch("origin/" <> head)}")

    branch_names =
      comparisons |> Enum.map(fn [{branch_1, _}, {_, _}] -> Style.branch(branch_1) end)

    branch_compare_data =
      comparisons
      |> Enum.map(fn [{_, branch_1_ahead}, {_, branch_2_ahead}] ->
        Style.ahead("↑ #{branch_1_ahead}") <> " " <> Style.behind("↓ #{branch_2_ahead}")
      end)

    IO.puts(Style.two_cols(branch_names, branch_compare_data))
  end

  def contrast(comparisons) do
    IO.puts("")
    IO.puts("Local branches compared upstream")

    [branch_names, origin_branch_names] =
      comparisons
      |> Enum.reduce([[], []], fn compare_data, [branches_acc, origins_acc] ->
        case compare_data do
          [{branch_1, _}, _] ->
            [
              [Style.branch(branch_1) | branches_acc],
              [Style.head_branch("origin/#{branch_1}") | origins_acc]
            ]

          {:no_upstream, branch_1} ->
            [
              [Style.branch(branch_1) | branches_acc],
              ["" | origins_acc]
            ]
        end
      end)
      |> Enum.map(&Enum.reverse/1)

    branch_compare_data =
      comparisons
      |> Enum.map(fn compare_data ->
        case compare_data do
          [{_, branch_1_ahead}, {_, branch_2_ahead}] ->
            Style.ahead("↑ #{branch_1_ahead}") <>
              " " <> Style.behind("↓ #{branch_2_ahead}")

          {:no_upstream, _branch_1} ->
            Style.error("× no upstream")
        end
      end)

    IO.puts(
      Style.two_cols(branch_names, branch_compare_data)
      |> String.split("\n")
      |> Style.two_cols(origin_branch_names)
    )
  end

  def error(msg) do
    IO.puts(Style.error(msg))
  end

  def invalid_arguments do
    IO.puts("")
    Render.error("Error: invalid arguments")
    IO.puts("Use one of the following:")
    IO.puts("branchy compare")
    IO.puts("branchy contrast")
    IO.puts("branchy sync")
    IO.puts("branchy inspect")
    IO.puts("")
  end
end
