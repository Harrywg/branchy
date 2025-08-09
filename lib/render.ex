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

  def push_msg(msg) do
    IO.puts("")
    IO.puts(msg)
  end

  def error(msg) do
    IO.puts(Style.error(msg))
  end
end
