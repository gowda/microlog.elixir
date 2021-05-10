defmodule MicroLogWeb.UserControllerTest do
  use MicroLogWeb.ConnCase

  alias MicroLog.Accounts

  @create_attrs %{
    email: "user@example.org",
    name: "test user name",
    password: "password",
    password_confirmation: "password"
  }
  @update_attrs %{email: "user.updated@example.org", name: "updated test user name"}
  @invalid_attrs %{email: nil, name: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    setup [:create_user, :create_admin]

    test "redirects to login path when not logged in", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert redirected_to(conn) =~ "/login"
    end

    test "redirects to home when not admin", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> get(Routes.user_path(conn, :index))

      assert redirected_to(conn) =~ "/"
    end

    test "lists all users for admin", %{conn: conn, admin: admin} do
      conn =
        conn
        |> assign(:current_user, admin)
        |> get(Routes.user_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign up"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Sign up"
    end
  end

  describe "update user" do
    setup [:create_user, :create_other_user]

    test "redirects to login path when not logged in", %{conn: conn, user: user} do
      conn =
        put(conn, Routes.user_path(conn, :update, user), user: %{name: "updated test user name"})

      assert redirected_to(conn) == "/login"
    end

    test "redirects to home when logged in as different user", %{
      conn: conn,
      user: user,
      other_user: other_user
    } do
      conn =
        conn
        |> assign(:current_user, other_user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: "updated test user name"})

      assert redirected_to(conn) == "/"
    end

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: "updated test user name"})

      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "renders error when attempted to update email", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> put(Routes.user_path(conn, :update, user), user: @update_attrs)

      assert html_response(conn, 200) =~ "Update your profile"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> put(Routes.user_path(conn, :update, user), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "Update your profile"
    end
  end

  describe "delete user" do
    setup [:create_user, :create_other_user]

    test "redirects to login path when not logged in", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))

      assert redirected_to(conn) == "/login"
    end

    test "redirects to home when logged in as different user", %{
      conn: conn,
      user: user,
      other_user: other_user
    } do
      conn =
        conn
        |> assign(:current_user, other_user)
        |> delete(Routes.user_path(conn, :delete, user))

      assert redirected_to(conn) == "/"
    end

    test "deletes chosen user", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> delete(Routes.user_path(conn, :delete, user))

      assert redirected_to(conn) == Routes.user_path(conn, :index)

      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end

  defp create_other_user(_) do
    {:ok, user} =
      Accounts.create_user(%{
        email: "other.user@example.org",
        name: "other test user name",
        password: "password",
        password_confirmation: "password"
      })

    %{other_user: user}
  end

  defp create_admin(_) do
    {:ok, user} =
      Accounts.create_user(%{
        email: "admin.user@example.org",
        name: "test admin name",
        password: "password",
        password_confirmation: "password",
        admin: true
      })

    %{admin: user}
  end
end
