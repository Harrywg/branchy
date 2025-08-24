defmodule Mix.Tasks.Branchy do
  use Mix.Task

  def run(args) do
    Branchy.main(args)
  end
end
