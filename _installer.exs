# tmp installer to make built exe globally accessible

#!/usr/bin/env elixir

source   = Path.expand("./burrito_out/branchy_macos")
target   = "/usr/local/bin/branchy"

unless File.exists?(source) do
  IO.puts(:stderr, "Could not find built executable at #{source}")
  IO.puts("Run `mix escript.build` first.")
  System.halt(1)
end

File.rm_rf!(target)
File.cp!(source, target)
File.chmod!(target, 0o755)

IO.puts("Installed \n- #{source}\nto\n- #{target}")
