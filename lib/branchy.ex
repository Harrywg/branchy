defmodule Branchy do
  def main(args) do
    case args do
      ["compare"] ->
        Controller.compare()

      ["contrast"] ->
        Controller.contrast()

      ["sync"] ->
        Controller.sync()

      ["inspect"] ->
        Controller.inspect()

      [""] ->
        IO.puts("Please provide an argument")

      _ ->
        IO.puts("Invalid arguments")
    end
  end
end
