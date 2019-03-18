defmodule Mixnix.MixProject do
  use Mix.Project

  def project do
    [
      app: :mixnix,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Mixnix.CLI],
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:mix_test_watch, "~> 0.9.0", only: [:dev]},
      {:dialyxir, "~> 0.5", only: [:dev]},
      {:syringe, "~> 1.1"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:jsone, "~> 1.4"},
      {:hex_core, "~> 0.5"}
    ]
  end
end
