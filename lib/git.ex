defmodule Git do
  def status do
    {git_status_raw, _exit_status} = System.cmd("git", ["status"])
    git_status = Terminal.read_terminal_output(git_status_raw)
    IO.inspect(git_status)
  end

  def compare(branch_1, branch_2) when is_binary(branch_1) and is_binary(branch_2) do
    {rev_list_raw, _exit_status} =
      System.cmd("git", ["rev-list", "--left-right", "--count", branch_1, branch_2])

    rev_list = Terminal.read_terminal_output(rev_list_raw)

    IO.inspect(rev_list)
  end

  def compare(_, _) do
    {:error, "couldn't parse args"}
  end
end
