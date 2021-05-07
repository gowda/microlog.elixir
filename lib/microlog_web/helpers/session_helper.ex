defmodule MicroLogWeb.SessionHelper do
  @moduledoc false

  import Plug.Conn

  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
