defmodule MicroLog.UserProfileEditTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  describe "profile" do
    setup [:create_user, :create_other_user, :create_admin]

    feature "redirects to login page when not logged in", %{session: session, user: user} do
      session
      |> visit("/users/#{user.id}/edit")
      |> assert_has(Query.text("Please login to access this page"))
      |> assert_has(Query.fillable_field("email"))
      |> assert_has(Query.fillable_field("password"))
      |> assert_has(Query.button("Log in"))
    end

    feature "redirects to home page when logged in as wrong user", %{
      session: session,
      user: user,
      other_user: other_user
    } do
      session
      |> login(other_user)
      |> visit("/users/#{user.id}/edit")
      |> assert_has(Query.text("You cannot edit profile for other users."))
    end

    feature "form has fields", %{session: session, user: user} do
      session
      |> visit("/login")
      |> login(user)
      |> click(Query.link("Settings"))
      |> assert_has(Query.text("Update your profile"))
      |> assert_has(Query.fillable_field("user[name]"))
      |> assert_has(Query.fillable_field("user[email]"))
      |> assert_has(Query.button("Save changes"))
    end

    feature "form has fields when logged in as admin", %{
      session: session,
      user: user,
      admin: admin
    } do
      session
      |> visit("/login")
      |> login(admin)
      |> visit("/users/#{user.id}/edit")
      |> assert_has(Query.text("Update your profile"))
      |> assert_has(Query.fillable_field("user[name]"))
      |> assert_has(Query.fillable_field("user[email]"))
      |> assert_has(Query.button("Save changes"))
    end

    feature "submitting blank form shows errors", %{session: session, user: user} do
      session
      |> login(user)
      |> click(Query.link("Settings"))
      |> clear(Query.fillable_field("user[name]"))
      |> clear(Query.fillable_field("user[email]"))
      |> click(Query.button("Save changes"))
      |> assert_has(Query.text("Oops, something went wrong! Please check the errors below."))
      |> assert_has(Query.text("Name can't be blank"))
    end

    feature "submitting form with changed email shows errors", %{session: session, user: user} do
      session
      |> login(user)
      |> click(Query.link("Settings"))
      |> clear(Query.fillable_field("user[email]"))
      |> fill_in(Query.fillable_field("user[email]"), with: "updated.user@example.org")
      |> click(Query.button("Save changes"))
      |> assert_has(Query.text("Oops, something went wrong! Please check the errors below."))
      |> assert_has(Query.text("Email cannot be updated"))
    end

    feature "submitting form with valid name", %{session: session, user: user} do
      session
      |> login(user)
      |> click(Query.link("Settings"))
      |> fill_in(Query.text_field("user[name]"), with: "Updated test user name")
      |> click(Query.button("Save changes"))
      |> assert_has(Query.text("Profile updated successfully."))
    end

    defp login(session, user) do
      session
      |> visit("/login")
      |> fill_in(Query.fillable_field("email"), with: user.email)
      |> fill_in(Query.fillable_field("password"), with: "password")
      |> click(Query.button("Log in"))
    end
  end

  defp create_user(_) do
    {:ok, user} =
      MicroLog.Accounts.create_user(%{
        email: "user@example.org",
        name: "test user name",
        password: "password",
        password_confirmation: "password"
      })

    %{user: user}
  end

  defp create_other_user(_) do
    {:ok, user} =
      MicroLog.Accounts.create_user(%{
        email: "other.user@example.org",
        name: "other test user name",
        password: "password",
        password_confirmation: "password"
      })

    %{other_user: user}
  end

  defp create_admin(_) do
    {:ok, user} =
      MicroLog.Accounts.create_user(%{
        email: "admin.user@example.org",
        name: "test admin name",
        password: "password",
        password_confirmation: "password",
        admin: true
      })

    %{admin: user}
  end
end
