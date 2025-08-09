defmodule Git do
  @spec read_terminal_output(binary()) :: list()
  defp read_terminal_output(output_str) do
    output_str_arr = String.split(output_str, "\n")

    output_str_arr
    |> Enum.map(fn str -> String.trim(str) end)
    |> Enum.filter(fn str -> String.length(str) > 0 end)
  end

  defp compare_two_branches(branch_1, branch_2)
       when is_binary(branch_1) and is_binary(branch_2) do
    with {branch_1_ahead_raw, 0} <-
           System.cmd("git", ["rev-list", "--count", branch_1, "^#{branch_2}"]),
         {branch_2_ahead_raw, 0} <-
           System.cmd("git", ["rev-list", "--count", branch_2, "^#{branch_1}"]) do
      branch_1_ahead = branch_1_ahead_raw |> read_terminal_output() |> List.first()
      branch_2_ahead = branch_2_ahead_raw |> read_terminal_output() |> List.first()

      {
        :ok,
        [{branch_1, branch_1_ahead}, {branch_2, branch_2_ahead}]
      }

      # "#{Style.branch(branch_1)} ↑ #{branch_1_ahead} ↓ #{branch_2_ahead}"
      # "#{Style.branch(branch_1)} is #{branch_1_ahead} commits ahead, #{branch_2_ahead} behind #{Style.branch(branch_2)}"
    else
      {_, exit_status} ->
        {:error, "Failed to compare branches: git command exited with status #{exit_status}"}
    end
  end

  @spec compare_branches_to_head(list(), binary()) :: {:error, binary()} | {:ok, list()}
  def compare_branches_to_head(branches, head) do
    branches
    |> Enum.reduce_while([], fn branch, acc ->
      case compare_two_branches(branch, "origin/#{head}") do
        {:ok, compare_data} ->
          {:cont, [compare_data | acc]}

        error ->
          {:halt, error}
      end
    end)
    |> case do
      {:error, error} -> {:error, error}
      comparisons -> {:ok, Enum.reverse(comparisons)}
    end
  end

  @spec get_all_local_branches() :: {:error, <<_::64, _::_*8>>} | {:ok, list()}
  def get_all_local_branches do
    case System.cmd("git", ["branch"]) do
      {all_branches_raw, 0} ->
        all_branches = read_terminal_output(all_branches_raw)

        # Remove current branch indentifier
        all_branches_cleaned =
          Enum.map(all_branches, fn
            "* " <> branch_name -> branch_name
            branch_name -> branch_name
          end)

        {:ok, all_branches_cleaned}

      {_, exit_status} ->
        {:error, "Failed to get local branches: git command exited with status #{exit_status}"}
    end
  end

  @spec get_remote_head() :: {:error, <<_::144>>} | {:ok, binary()}
  def get_remote_head do
    case System.cmd("git", ["remote", "show", "origin"]) do
      {remote_branches_raw, 0} ->
        remote_branches = read_terminal_output(remote_branches_raw)

        head =
          Enum.reduce(remote_branches, fn ln, acc ->
            case ln do
              "HEAD branch: " <> branch_name -> branch_name
              _ -> acc
            end
          end)

        {:ok, head}

      {_, exit_status} ->
        {:error, "Failed to get HEAD from origin: git command exited with status #{exit_status}"}
    end
  end

  @spec fetch() :: :ok | {:error, <<_::240>>}
  def fetch do
    fetch_res = System.cmd("git", ["fetch"])

    case fetch_res do
      {_, 0} ->
        :ok

      {_, exit_status} ->
        {:error, "Failed to fetch remote branches: git command exited with status #{exit_status}"}
    end
  end
end
