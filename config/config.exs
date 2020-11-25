# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :darktan,
  ecto_repos: [Darktan.Repo]

# Configures the endpoint
config :darktan, DarktanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1eSloEyoTGumw/f95u3fiPmXxsZ/QCetZZl08Z2Ycq8OeS2iszyV82/T57pgyjRV",
  render_errors: [view: DarktanWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Darktan.PubSub,
  live_view: [signing_salt: "l+mXOzEO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
