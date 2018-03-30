defmodule Google do
  use OAuth2.Strategy

  # Public API

  def client do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: Application.get_env(:voting_web, :oauth_client),
      client_secret: Application.get_env(:voting_web, :oauth_secret),
      redirect_uri: redirect_uri(),
      site: "https://accounts.google.com",
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://accounts.google.com/o/oauth2/token"
    )
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "email profile")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  defp redirect_uri() do
    "http://6764f512.ngrok.io" <> "/auth/google/callback"
  end
end
