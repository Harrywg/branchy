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

      _ ->
        Render.invalid_arguments()
    end
  end
end
