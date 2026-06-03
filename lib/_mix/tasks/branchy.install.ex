defmodule Mix.Tasks.Branchy.Install do
  use Mix.Task

  @shortdoc "Installs the Branchy CLI binary from burrito_out"
  @valid_targets ~w(macos linux)

  def run(args) do
    target_os = parse_target(args)
    source = Path.expand("burrito_out/branchy_#{target_os}")
    target = Path.expand("/usr/local/bin/branchy")

    unless File.exists?(source) do
      Mix.raise("Source binary not found at #{source}")
    end

    File.mkdir_p!(Path.dirname(target))
    File.cp!(source, target)
    File.chmod!(target, 0o755)

    Mix.shell().info("Branchy CLI installed to #{target}")
  end

  defp parse_target([os | _]) when os in @valid_targets, do: os

  defp parse_target([os | _]),
    do: Mix.raise("Unknown target OS #{inspect(os)}. Valid options: #{Enum.join(@valid_targets, ", ")}")

  defp parse_target([]) do
    case :os.type() do
      {:unix, :darwin} -> "macos"
      {:unix, _} -> "linux"
      other -> Mix.raise("Unsupported OS #{inspect(other)}. Pass a target explicitly: #{Enum.join(@valid_targets, ", ")}")
    end
  end
end
