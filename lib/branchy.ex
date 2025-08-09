defmodule Branchy do
  def main(args) do
    case args do
      ["compare"] ->
        local_branches = Git.get_all_local_branches()
        head = Git.get_remote_head()

        comparison_results =
          Enum.map(local_branches, fn branch ->
            Git.compare_two_branches(branch, "origin/#{head}")
          end)

        Render.compare(head, comparison_results)

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
