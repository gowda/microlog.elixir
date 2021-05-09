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
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
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
    setup [:create_user]

    test "returns 401 when not logged in", %{conn: conn, user: user} do
      conn =
        put(conn, Routes.user_path(conn, :update, user), user: %{name: "updated test user name"})

      assert html_response(conn, 401) =~ "You should be logged in to update profile"
    end

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: "updated test user name"})

      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "updated test user name"
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
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
