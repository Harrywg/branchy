defmodule Branchy do
  def main(args) do
    case args do
      ["compare"] ->
        IO.puts("compare:")
        IO.puts("will compare all local branches against main branch")
        # Get all branches
        branches = Git.get_all_branches()

      # Get main branch if available via remote
      # If not available, prompt user to set one locally
      # Loop through main branches and Git.compare()

      ["contrast"] ->
        IO.puts("contrast:")
        IO.puts("will check all local branches against remote counterparts if exists")

      ["inspect"] ->
        IO.puts("inspect")

        IO.puts(
          "will run a health check on local branches and highlight any branches okay to delete"
        )

      [""] ->
        IO.puts("Please provide an argument")

      _ ->
        IO.puts("Invalid arguments")
    end
  end
end
