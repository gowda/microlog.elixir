defmodule MicroLogWeb.Router do
  use MicroLogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MicroLogWeb do
    pipe_through [:browser, :authenticate_user]

    # forward?
    get "/", PageController, :home

    get "/home", PageController, :home
    get "/help", PageController, :help
    get "/about", PageController, :about
    get "/contact", PageController, :contact

    get "/signup", UserController, :new
    get "/login", SessionController, :new

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
  end

  scope "/", MicroLogWeb do
    pipe_through [:browser, :authenticate_user, :require_authentication]

    resources "/users", UserController, except: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MicroLogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MicroLogWeb.Telemetry
    end
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn

      user_id ->
        assign(conn, :current_user, MicroLog.Accounts.get_user!(user_id))
    end
  end

  def require_authentication(conn, _) do
    case Map.get(conn.assigns, :current_user) do
      %MicroLog.Accounts.User{} ->
        conn

      _ ->
        conn
        |> put_flash(:info, "Please login to access this page.")
        |> redirect(to: "/login")
        |> halt
    end
  end
end
