# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :compare_web,
  namespace: CompareWeb

# Configures the endpoint
config :compare_web, CompareWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kveRqFnNONiLWnS4be27e5WxIjUokqPQ71DNIl0Z/TJt5fqif3q/tvPbXOsGesUB",
  render_errors: [view: CompareWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CompareWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :compare_web, :generators,
  context_app: :compare

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
