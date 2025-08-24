defmodule Branchy.Application do
  use Application

  def start(_type, _args) do
    env = System.get_env("MIX_ENV") || "prod"

    case env do
      "prod" ->
        Task.start_link(fn ->
          args =
            if Code.ensure_loaded?(Burrito.Util.Args),
              do: Burrito.Util.Args.argv(),
              else: System.argv()

          Branchy.main(args)
          System.halt()
        end)

      "dev" ->
        Task.start_link(fn ->
          args = System.argv()
          Branchy.main(args)
        end)

      "test" ->
        Task.start_link(fn ->
          Process.sleep(:infinity)
        end)
    end
  end
end
