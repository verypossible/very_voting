defmodule VotingWeb.AuthControllerTest do
  use VotingWeb.ConnCase

  test "GET /auth/google", %{conn: conn} do
    conn = get(conn, "/auth/google")
    assert redirected_to(conn) =~ "accounts.google.com/o/oauth2/auth"
  end

  test "GET /auth/not_google", %{conn: conn} do
    assert_raise RuntimeError, "No matching provider available", fn ->
      get(conn, "/auth/facebook")
    end
  end

  test "DELETE /auth/logout", %{conn: conn} do
    conn = delete(conn, "/auth/logout")
    assert redirected_to(conn) =~ "/"
  end

  test "GET /auth/get_user with user", %{conn: conn} do
    user = %{"email" => "test@test.com", "picture" => "no.jpg", "name" => "test"}

    conn = conn
      |> assign(:current_user, user)
      |> get("/auth/get_user")

    assert %{"token" => token, "email" => email, "picture" => picture, "name" => name} = json_response(conn, 200)
    assert email == user["email"]
    assert picture == user["picture"]
    assert name == user["name"]
    assert String.trim(token) != ""
  end

  test "GET /auth/get_user without user", %{conn: conn} do
    conn = get(conn, "/auth/get_user")
    assert conn.status == 401
    assert conn.resp_body == ""
  end
end
