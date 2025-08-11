defmodule Branchy.Application do
  use Application

  def start(_type, _args) do
    Task.start_link(fn ->
      args =
        if Code.ensure_loaded?(Burrito.Util.Args),
          do: Burrito.Util.Args.argv(),
          else: System.argv()

      Branchy.main(args)
      System.halt()
    end)
  end
end
