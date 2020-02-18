# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wait_list,
  ecto_repos: [WaitList.Repo]

# Configures the endpoint
config :wait_list, WaitListWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gqvtGduP5C5brdpaybz0WNn/RkClj6qLGYcduRxUBZIrbKrECOisK4PWODx18pTd",
  render_errors: [view: WaitListWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WaitList.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "FEa6kvfI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :wait_list, :pow,
  user: WaitList.Users.User,
  repo: WaitList.Repo,
  web_module: WaitListWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
