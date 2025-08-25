defmodule Branchy.MixProject do
  use Mix.Project

  def project do
    [
      app: :branchy,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Branchy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:burrito, "~> 1.4.0"}
    ]
  end

  def releases do
    [
      branchy: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            macos: [os: :darwin, cpu: :aarch64]
          ]
        ]
      ]
    ]
  end

  defp aliases do
    [
      "branchy.replace": [
        "branchy.uninstall",
        "branchy.install"
      ],
      "branchy.release": [
        "cmd rm -rf ./burrito_out ./_build",
        "clean",
        "compile",
        "release --overwrite",
        "cmd ./burrito_out/branchy_macos cache_clear",
        "cmd BURRITO_LOG_LEVEL=silent BURRITO_TARGET=macos MIX_ENV=prod mix release --overwrite"
      ]
    ]
  end
end
