defmodule Style do
  @spec upstream_branch(binary()) :: binary()
  def upstream_branch(str) do
    IO.ANSI.cyan() <> str <> IO.ANSI.reset()
  end

  @spec branch(binary()) :: binary()
  def branch(str) do
    IO.ANSI.blue() <> str <> IO.ANSI.reset()
  end

  @spec ahead(binary()) :: binary()
  def ahead(str) do
    IO.ANSI.light_yellow() <> str <> IO.ANSI.reset()
  end

  @spec behind(binary()) :: binary()
  def behind(str) do
    IO.ANSI.light_red() <> str <> IO.ANSI.reset()
  end

  @spec error(binary()) :: binary()
  def error(str) do
    IO.ANSI.red() <> str <> IO.ANSI.reset()
  end

  @spec success(binary()) :: binary()
  def success(str) do
    IO.ANSI.green() <> str <> IO.ANSI.reset()
  end

  def faded(str) do
    IO.ANSI.light_black() <> str <> IO.ANSI.reset()
  end

  def two_cols(col_1_list, col_2_list) do
    # Strip ANSI formatting
    visual_length = fn str ->
      str
      |> String.replace(~r/\e\[[0-9;]*m/, "")
      |> String.length()
    end

    col_1_most_chars =
      Enum.reduce(col_1_list, 0, fn str, acc ->
        max(visual_length.(str), acc)
      end)

    col_1_list
    |> Enum.with_index()
    |> Enum.reduce("", fn {col_1, i}, acc ->
      padding_needed = col_1_most_chars - visual_length.(col_1)
      line = "#{col_1}#{String.duplicate(" ", padding_needed)}  #{Enum.at(col_2_list, i)}\n"

      acc <> line
    end)
  end
end
