# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :typing_maojo,
  ecto_repos: [TypingMaojo.Repo]

# Configures the endpoint
config :typing_maojo, TypingMaojoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PBKgg+sVs9crJGtDZB8+V7IHUU2c1voHsbMKrH4lFPcgryB9vxMX2KmHnDkHBKrw",
  render_errors: [view: TypingMaojoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TypingMaojo.PubSub,
  live_view: [signing_salt: "Dogvfe6Q"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
