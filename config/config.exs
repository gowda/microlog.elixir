# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :microlog,
  namespace: MicroLog,
  ecto_repos: [MicroLog.Repo]

# Configures the endpoint
config :microlog, MicroLogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gMkAneJxO04qya9WhFcsY4P4/je5S+5JeRH5/iaj4b3LDhC0EP8eqiGIwCr1Kezy",
  render_errors: [view: MicroLogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MicroLog.PubSub,
  live_view: [signing_salt: "5DSThqL0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
