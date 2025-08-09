defmodule Terminal do
  def read_terminal_output(output_str) do
    output_str_arr = String.split(output_str, "\n")

    output_str_arr
    |> Enum.map(fn str -> String.trim(str) end)
    |> Enum.filter(fn str -> String.length(str) > 0 end)
  end

  def log_compare(head, comparisons) do
    IO.puts("Comparing local branches to remote heads local variant...")
    IO.puts("HEAD: #{head}")

    Enum.each(comparisons, fn msg ->
      IO.puts(msg)
    end)
  end
end
