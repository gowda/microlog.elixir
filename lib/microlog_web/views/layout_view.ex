defmodule MicroLogWeb.LayoutView do
  use MicroLogWeb, :view

  def title(conn) do
    case conn.assigns do
      %{title: title} -> "#{title} | Phoenix Sample App"
      _ -> "Phoenix Sample App"
    end
  end

  def headers(conn) do
    conn.req_headers
    |> Enum.filter(fn {k, _} -> k != "cookie" end)
    |> Enum.map(fn {k, v} -> {transform_header_key(k), v} end)
  end

  defp transform_header_key("dnt") do
    "DNT"
  end

  defp transform_header_key(string) do
    string
    |> String.split("-")
    |> Enum.map(fn s -> String.capitalize(s) end)
    |> Enum.join("-")
  end
end
