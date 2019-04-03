use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :attend, AttendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :attend, Attend.Repo,
  username: "postgres",
  password: "postgres",
  database: "attend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "attend_eventstore_test",
  hostname: "localhost",
  pool_size: 10

if File.exists?("config/test.secret.exs") do
  import_config "test.secret.exs"
end
