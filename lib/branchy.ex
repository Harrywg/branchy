defmodule Branchy do
  def main(args) do
    case args do
      ["compare"] ->
        Cmd.compare()

      ["contrast"] ->
        Cmd.contrast()

      ["inspect"] ->
        Cmd.inspect()

      [""] ->
        IO.puts("Please provide an argument")

      _ ->
        IO.puts("Invalid arguments")
    end
  end
end
