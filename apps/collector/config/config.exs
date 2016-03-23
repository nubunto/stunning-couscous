use Mix.Config
config :collector, port: 4040
config :collector, Collector.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "parallel_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
