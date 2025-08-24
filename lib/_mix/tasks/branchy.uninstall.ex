defmodule Mix.Tasks.Branchy.Uninstall do
  use Mix.Task

  @shortdoc "Removes the Branchy CLI binary from ~/bin"

  def run(_args) do
    target = Path.expand("/usr/local/bin/branchy")

    if File.exists?(target) do
      File.rm!(target)
      Mix.shell().info("Branchy CLI removed from #{target}")
    else
      Mix.shell().info("Branchy CLI not found at #{target}")
    end
  end
end
