defmodule MicroLogWeb.LayoutView do
  use MicroLogWeb, :view

  def title(conn) do
    case conn.assigns do
      %{title: title} -> "#{title} | Phoenix Sample App"
      _ -> "Phoenix Sample App"
    end
  end
end
