use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :microlog, MicroLog.Repo,
  username: "postgres",
  password: "postgres",
  database: "microlog_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :microlog, MicroLogWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :microlog, :sandbox, Ecto.Adapters.SQL.Sandbox

config :wallaby, driver: Wallaby.Chrome, chromedriver: [headless: true]
config :wallaby, otp_app: :microlog
config :wallaby, screenshot_on_failure: true
