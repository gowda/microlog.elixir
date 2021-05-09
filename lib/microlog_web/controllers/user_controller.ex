defmodule MicroLogWeb.UserController do
  use MicroLogWeb, :controller

  alias MicroLog.Accounts
  alias MicroLog.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to Phoenix Sample App!")
        |> login(user)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    case Map.get(conn.assigns, :current_user) do
      %User{} ->
        user = Accounts.get_user!(id)
        changeset = Accounts.change_user(user)
        render(conn, "edit.html", user: user, changeset: changeset)

      _ ->
        conn
        |> put_flash(:info, "Please login to access this page.")
        |> redirect(to: "/login")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Map.get(conn.assigns, :current_user) do
      %User{} ->
        user = Accounts.get_user!(id)

        case Accounts.update_user(user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "Profile updated successfully.")
            |> redirect(to: Routes.user_path(conn, :show, user))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end

      _ ->
        conn
        |> put_flash(:info, "You should be logged in to update profile")
        |> put_status(401)
        |> put_view(MicroLogWeb.SessionView)
        |> render("new.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
