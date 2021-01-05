defmodule MicroLogWeb.PageControllerTest do
  use MicroLogWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<title>Home | Phoenix Sample App</title>"
  end

  test "GET /home", %{conn: conn} do
    conn = get(conn, "/home")
    assert html_response(conn, 200) =~ "<title>Home | Phoenix Sample App</title>"
  end

  test "GET /help", %{conn: conn} do
    conn = get(conn, "/help")
    assert html_response(conn, 200) =~ "<title>Help | Phoenix Sample App</title>"
  end

  test "GET /about", %{conn: conn} do
    conn = get(conn, "/about")
    assert html_response(conn, 200) =~ "<title>About | Phoenix Sample App</title>"
  end

  test "GET /contact", %{conn: conn} do
    conn = get(conn, "/contact")
    assert html_response(conn, 200) =~ "<title>Contact | Phoenix Sample App</title>"
  end
end
