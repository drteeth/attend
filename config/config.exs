# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :attend,
  ecto_repos: [Attend.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :attend, AttendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7YBLmGXSxZHvDe7PqsuTu/Qu4OWrcgkeUKHR0z1IySK08sdK/z98wMJHkXNqg4Hp",
  render_errors: [view: AttendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Attend.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "dO7Q7E/ywsVTEuyipG+9ffo7tvym/XNt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Attend.Repo

# Commands are eventually consistent by default
config :commanded, default_consistency: :eventual

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
