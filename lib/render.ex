defmodule Render do
  def compare(head, comparisons) do
    IO.puts("Comparing local branches to remote head...")
    IO.puts("HEAD: origin/#{head}")

    Enum.each(comparisons, fn msg ->
      IO.puts(msg)
    end)
  end

  def error({:error, message}) do
    IO.puts(message)
  end
end
