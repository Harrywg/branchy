defmodule Style do
  @spec head_branch(binary()) :: binary()
  def head_branch(str) do
    IO.ANSI.cyan() <> str <> IO.ANSI.reset()
  end

  @spec branch(binary()) :: binary()
  def branch(str) do
    IO.ANSI.blue() <> str <> IO.ANSI.reset()
  end

  @spec ahead(binary()) :: binary()
  def ahead(str) do
    IO.ANSI.green() <> str <> IO.ANSI.reset()
  end

  @spec behind(binary()) :: binary()
  def behind(str) do
    IO.ANSI.red() <> str <> IO.ANSI.reset()
  end

  @spec error(binary()) :: binary()
  def error(str) do
    IO.ANSI.red() <> str <> IO.ANSI.reset()
  end

  # @spec two_cols(list(binary(), list(binary())))
  def two_cols(col_1_list, col_2_list) do
    col_1_most_chars =
      Enum.reduce(col_1_list, 0, fn str, acc ->
        max(String.length(str), acc)
      end)

    col_1_list
    |> Enum.with_index()
    |> Enum.reduce("", fn {col_1, i}, acc ->
      line =
        "#{String.pad_trailing(col_1, col_1_most_chars)}  #{Enum.at(col_2_list, i)}\n"

      acc <> line
    end)
  end
end
