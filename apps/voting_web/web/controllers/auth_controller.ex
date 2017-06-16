defmodule VotingWeb.AuthController do
  require Logger
  use VotingWeb.Web, :controller

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    token = get_token!(provider, code)
    user = get_user!(provider, token)

    conn
      |> put_session(:current_user, user)
      |> redirect(to: "/")
  end

  def delete(conn, _params) do
    conn
      |> put_flash(:info, "You have been logged out!")
      |> configure_session(drop: true)
      |> redirect(to: "/")
  end

  def get_user(conn, _params) do
    user = conn.assigns[:current_user] || get_session(conn, :current_user)

    if user do
      token = Phoenix.Token.sign(conn, "user", user["email"])
      json(conn, %{token: token, picture: user["picture"], name: user["name"], email: user["email"]})
    else
      conn
        |> send_resp(401, "")
    end
  end

  defp authorize_url!("google") do
    Google.authorize_url!()
  end

  defp authorize_url!(_) do
    raise "No matching provider available"
  end

  defp get_token!("google", code) do
    Google.get_token!(code: code)
  end

  defp get_token!(_, _) do
    raise "No matching provider available"
  end

  defp get_user!("google", token) do
    user_url = "https://www.googleapis.com/plus/v1/people/me/openIdConnect"
    case OAuth2.Client.get(token, user_url) do
      {:ok, %OAuth2.Response{body: user}} ->
        user
      {:error, %OAuth2.Response{status_code: 401}} ->
        Logger.error("Unauthorized token")
      {:error, %OAuth2.Error{reason: reason}} ->
        Logger.error("Error: #{inspect reason}")
    end
  end
end
