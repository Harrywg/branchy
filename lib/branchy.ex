defmodule Branchy do
  def main(args) do
    case args do
      ["compare"] ->
        IO.puts("compare:")
        IO.puts("will compare all local branches against main branch")
      ["contrast"] ->
        IO.puts("contrast:")
        IO.puts("will check all local branches against remote counterparts if exists")
      ["inspect"] ->
        IO.puts("inspect")
        IO.puts("will run a health check on local branches and highlight any branches okay to delete")
      [""] ->
        IO.puts("Please provide an argument")
      _ ->
        IO.puts("Invalid arguments")
    end
  end
end
