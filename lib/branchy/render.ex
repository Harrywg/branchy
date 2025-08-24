defmodule Render do
  def compare(head, comparisons) do
    IO.puts("")

    [local_branches, upstream_branches] =
      comparisons
      |> Enum.reduce([[], []], fn compare_data, [local_acc, upstream_acc] ->
        case compare_data do
          [{branch_1, _}, {_, _}] ->
            [
              [Style.branch(branch_1) | local_acc],
              [Style.faded("-> ") <> Style.upstream_branch("origin/#{head}") | upstream_acc]
            ]

          {:no_upstream, branch_1} ->
            [
              [Style.branch(branch_1) | local_acc],
              [Style.error("x") | upstream_acc]
            ]
        end
      end)
      |> Enum.map(&Enum.reverse/1)

    branch_compare_data =
      comparisons
      |> Enum.map(fn comparison ->
        case comparison do
          [{_, "0"}, {_, "0"}] ->
            Style.success("✓ up to date")

          [{_, branch_1_ahead}, {_, branch_2_ahead}] ->
            Style.ahead("↑ #{branch_1_ahead}") <> " " <> Style.behind("↓ #{branch_2_ahead}")
        end
      end)

    IO.puts(
      local_branches
      |> Style.two_cols(upstream_branches)
      |> String.split("\n")
      |> Style.two_cols(branch_compare_data)
    )
  end

  def contrast(comparisons) do
    IO.puts("")

    [local_branches, upstream_branches] =
      comparisons
      |> Enum.reduce([[], []], fn compare_data, [local_acc, upstream_acc] ->
        case compare_data do
          [{branch_1, _}, {_, _}] ->
            [
              [Style.branch(branch_1) | local_acc],
              [Style.faded("-> ") <> Style.upstream_branch("origin/#{branch_1}") | upstream_acc]
            ]

          {:no_upstream, branch_1} ->
            [
              [Style.branch(branch_1) | local_acc],
              [Style.error("x") | upstream_acc]
            ]
        end
      end)
      |> Enum.map(&Enum.reverse/1)

    branch_compare_data =
      comparisons
      |> Enum.map(fn compare_data ->
        case compare_data do
          [{_, "0"}, {_, "0"}] ->
            Style.success("✓ in sync")

          [{_, branch_1_ahead}, {_, branch_2_ahead}] ->
            Style.ahead("↑ #{branch_1_ahead}") <>
              " " <> Style.behind("↓ #{branch_2_ahead}")

          {:no_upstream, _branch_1} ->
            Style.error("x no upstream")
        end
      end)

    IO.puts(
      local_branches
      |> Style.two_cols(upstream_branches)
      |> String.split("\n")
      |> Style.two_cols(branch_compare_data)
    )
  end

  def inspect(comparisons, number_ok_branches) do
    IO.puts("")

    [local_branches, upstream_branches] =
      comparisons
      |> Enum.reduce([[], []], fn compare_data, [local_acc, upstream_acc] ->
        case compare_data do
          [{branch_1, _}, {_, _}] ->
            [
              [Style.branch(branch_1) | local_acc],
              [Style.faded("-> ") <> Style.upstream_branch("origin/#{branch_1}") | upstream_acc]
            ]

          {:no_upstream, branch_1} ->
            [
              [Style.branch(branch_1) | local_acc],
              [Style.error("") | upstream_acc]
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
            Style.error("x no upstream")
        end
      end)

    IO.puts(Style.faded("✓ Counted #{number_ok_branches} branches in sync with upstream"))

    IO.puts(
      local_branches
      |> Style.two_cols(upstream_branches)
      |> String.split("\n")
      |> Style.two_cols(branch_compare_data)
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
