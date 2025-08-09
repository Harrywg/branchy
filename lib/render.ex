defmodule Render do
  def compare(head, comparisons) do
    IO.puts("Comparing local branches to remote heads local variant...")
    IO.puts("HEAD: #{head}")

    Enum.each(comparisons, fn msg ->
      IO.puts(msg)
    end)
  end
end
