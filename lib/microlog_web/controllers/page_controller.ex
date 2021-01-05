defmodule MicroLogWeb.PageController do
  use MicroLogWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:title, "Home")
    |> render("home.html")
  end

  def help(conn, _params) do
    conn
    |> assign(:title, "Help")
    |> render("help.html")
  end

  def about(conn, _params) do
    conn
    |> assign(:title, "About")
    |> render("about.html")
  end

  def contact(conn, _params) do
    conn
    |> assign(:title, "Contact")
    |> render("contact.html")
  end
end
