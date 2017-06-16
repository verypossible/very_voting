defmodule VotingWeb.PageControllerTest do
  use VotingWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in with Google"
  end
end
