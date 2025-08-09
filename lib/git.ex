defmodule Git do
  @spec read_terminal_output(binary()) :: list()
  defp read_terminal_output(output_str) do
    output_str_arr = String.split(output_str, "\n")

    output_str_arr
    |> Enum.map(fn str -> String.trim(str) end)
    |> Enum.filter(fn str -> String.length(str) > 0 end)
  end

  @spec compare_two_branches(binary(), binary()) :: <<_::64, _::_*8>>
  def compare_two_branches(branch_1, branch_2) when is_binary(branch_1) and is_binary(branch_2) do
    {branch_1_ahead_raw, _exit_status} =
      System.cmd("git", ["rev-list", "--count", branch_1, "^#{branch_2}"])

    branch_1_ahead = read_terminal_output(branch_1_ahead_raw)

    {branch_2_ahead_raw, _exit_status} =
      System.cmd("git", ["rev-list", "--count", branch_2, "^#{branch_1}"])

    branch_2_ahead = read_terminal_output(branch_2_ahead_raw)

    # Return output msg to render
    "#{branch_1} is #{List.first(branch_1_ahead)} commits ahead, #{List.first(branch_2_ahead)} behind #{branch_2}"
  end

  @spec get_all_local_branches() :: list()
  def get_all_local_branches do
    {all_branches_raw, _exit_status} = System.cmd("git", ["branch"])
    all_branches = read_terminal_output(all_branches_raw)

    # Remove current branch indentifier
    Enum.map(all_branches, fn
      "* " <> branch_name -> branch_name
      branch_name -> branch_name
    end)
  end

  @spec get_remote_head() :: {:error, <<_::144>>} | {:ok, binary()}
  def get_remote_head do
    {_, fetch_exit_status} = System.cmd("git", ["fetch"])

    case fetch_exit_status do
      0 ->
        {remote_branches_raw, _exit_status} = System.cmd("git", ["remote", "show", "origin"])
        remote_branches = read_terminal_output(remote_branches_raw)

        head =
          Enum.reduce(remote_branches, fn ln, acc ->
            case ln do
              "HEAD branch: " <> branch_name -> branch_name
              _ -> acc
            end
          end)

        {:ok, head}

      _ ->
        {:error, "Couldn't git fetch"}
    end
  end
end
