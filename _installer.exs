# tmp installer to make built exe globally accessible

#!/usr/bin/env elixir

bin_name = "branchy"
source   = Path.expand("./#{bin_name}") # adjust if different
target   = "/usr/local/bin/#{bin_name}"

unless File.exists?(source) do
  IO.puts(:stderr, "Could not find built executable at #{source}")
  IO.puts("Run `mix escript.build` first.")
  System.halt(1)
end

IO.puts("Copying #{source} -> #{target}")
File.cp!(source, target)
File.chmod!(target, 0o755)

IO.puts("Installed #{bin_name} to #{target}")
