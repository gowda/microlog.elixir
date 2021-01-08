defmodule MicroLog.AccountsTest do
  use MicroLog.DataCase

  alias MicroLog.Accounts

  describe "users" do
    alias MicroLog.Accounts.User

    @valid_attrs %{
      email: "test@example.org",
      name: "test user name",
      password: "password",
      password_confirmation: "password"
    }
    @invalid_attrs %{name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with blank data returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{})
    end

    test "create_user/1 with valid name & blank email returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{name: "test user name"})
    end

    test "create_user/1 with valid name, invalid email & blank password returns error" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{name: "test user name", email: "invalid email"})
    end

    test "create_user/1 with valid name & invalid email returns error" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{
                 name: "test user name",
                 email: "invalid",
                 password: "test password"
               })
    end

    test "create_user/1 with valid name, email & password returns success" do
      assert {:ok, %User{} = user} =
               Accounts.create_user(%{
                 name: "test user name",
                 email: "test@example.org",
                 password: "password"
               })

      assert user.name == "test user name"
      assert user.email == "test@example.org"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/2 with name updates name of the user" do
      user = user_fixture()

      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 name: "updated test user name"
               })

      assert user.name == "updated test user name"
    end

    test "update_user/2 with email returns error" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user, %{
                 email: "updated.user@example.org"
               })
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "authenticate_email_password/2 with invalid email & password returns error changeset" do
      user = user_fixture()

      refute Accounts.authenticate_email_password("invalid@example.org", "not the password")
    end

    test "authenticate_email_password/2 with valid email & password returns error changeset" do
      user = user_fixture()

      assert Accounts.authenticate_email_password("test@example.org", "password") == user
    end
  end
end
