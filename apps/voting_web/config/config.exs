# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :voting_web,
  oauth_client: System.get_env("OAUTH_CLIENT"),
  oauth_secret: System.get_env("OAUTH_SECRET")

# Configures the endpoint
config :voting_web, VotingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "B04/TUi/Zu5AAZPFRtSHTnuuCPzSNoBDb9DpsJHezRmAnqwirU7S81RDlNSGgNfw",
  render_errors: [view: VotingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VotingWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
