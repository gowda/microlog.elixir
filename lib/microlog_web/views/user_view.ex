defmodule MicroLogWeb.UserView do
  use MicroLogWeb, :view

  def gravatar_url_for(user) do
    gravatar_id(user.email) |> gravatar_url()
  end

  def gravatar_id(email) do
    :crypto.hash(:sha256, email)
    |> Base.encode16()
    |> String.downcase()
  end

  def gravatar_url(id) do
    "https://secure.gravatar.com/avatar/#{id}"
  end
end
