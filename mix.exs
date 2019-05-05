defmodule Attend.MixProject do
  use Mix.Project

  def project do
    [
      app: :attend,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Attend.Application, []},
      extra_applications: [:logger, :runtime_tools, :eventstore]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:commanded, "~> 0.18.0"},
      {:commanded_eventstore_adapter, "~> 0.5"},
      {:eventstore, "~> 0.16.1"},
      {:bamboo, "~> 1.2"},
      {:redix, "~> 0.10.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "event_store.reset": ["event_store.drop", "event_store.create", "event_store.init"],
      "attend.reset": [
        "event_store.drop",
        "ecto.drop",
        "ecto.create",
        "ecto.migrate",
        "event_store.create",
        "event_store.init",
        "projections.reset",
        "run priv/repo/seeds.exs"
      ],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
