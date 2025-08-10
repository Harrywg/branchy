defmodule Render do
  def compare(head, comparisons) do
    IO.puts("")

    branch_names =
      comparisons
      |> Enum.map(fn [{branch_1, _}, {_, _}] ->
        Style.branch(branch_1) <>
          Style.faded(" -> ") <> Style.upstream_branch("origin/#{head}")
      end)

    branch_compare_data =
      comparisons
      |> Enum.map(fn [{_, branch_1_ahead}, {_, branch_2_ahead}] ->
        Style.ahead("↑ #{branch_1_ahead}") <> " " <> Style.behind("↓ #{branch_2_ahead}")
      end)

    IO.puts(Style.two_cols(branch_names, branch_compare_data))
  end

  def contrast(comparisons) do
    IO.puts("")

    branch_names =
      comparisons
      |> Enum.map(fn compare_data ->
        case compare_data do
          [{branch_1, _}, {_, _}] ->
            Style.branch(branch_1) <>
              Style.faded(" -> ") <> Style.upstream_branch("origin/#{branch_1}")

          {:no_upstream, branch_1} ->
            Style.branch(branch_1) <>
              Style.faded(" -> ") <> Style.error("x")
        end
      end)

    branch_compare_data =
      comparisons
      |> Enum.map(fn compare_data ->
        case compare_data do
          [{_, branch_1_ahead}, {_, branch_2_ahead}] ->
            Style.ahead("↑ #{branch_1_ahead}") <>
              " " <> Style.behind("↓ #{branch_2_ahead}")

          {:no_upstream, _branch_1} ->
            Style.error("no upstream")
        end
      end)

    IO.puts(Style.two_cols(branch_names, branch_compare_data))
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
