defmodule Mix.Tasks.Branchy.Install do
  use Mix.Task

  @shortdoc "Installs the Branchy CLI binary from burrito_out"

  def run(_args) do
    source = Path.expand("burrito_out/branchy_macos")
    target = Path.expand("/usr/local/bin/branchy")

    unless File.exists?(source) do
      Mix.raise("Source binary not found at #{source}")
    end

    File.mkdir_p!(Path.dirname(target))
    File.cp!(source, target)
    File.chmod!(target, 0o755)

    Mix.shell().info("Branchy CLI installed to #{target}")
  end
end
