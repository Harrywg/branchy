defmodule Git do
  def status do
    {git_status_raw, _exit_status} = System.cmd("git", ["status"])
    git_status = Terminal.read_terminal_output(git_status_raw)
    IO.inspect(git_status)
  end

  def compare_two_branches(branch_1, branch_2) when is_binary(branch_1) and is_binary(branch_2) do
    {branch_1_ahead_raw, _exit_status} =
      System.cmd("git", ["rev-list", "--count", branch_1, "^#{branch_2}"])

    {branch_2_ahead_raw, _exit_status} =
      System.cmd("git", ["rev-list", "--count", branch_2, "^#{branch_1}"])

    branch_1_ahead = Terminal.read_terminal_output(branch_1_ahead_raw)
    branch_2_ahead = Terminal.read_terminal_output(branch_2_ahead_raw)

    # IO.puts("#{branch_1} is #{List.first(branch_1_ahead)} commits ahead of #{branch_2}")
    # IO.puts("#{branch_2} is #{List.first(branch_2_ahead)} commits ahead of #{branch_1}")

    {branch_1_ahead, branch_2_ahead}
  end

  def compare_two_branches(_, _) do
    {:error, "couldn't parse args"}
  end

  def get_all_branches do
    {all_branches_raw, _exit_status} = System.cmd("git", ["branch"])
    all_branches = Terminal.read_terminal_output(all_branches_raw)

    # Remove current branch indentifier
    Enum.map(all_branches, fn
      "* " <> branch_name -> branch_name
      branch_name -> branch_name
    end)
  end
end
