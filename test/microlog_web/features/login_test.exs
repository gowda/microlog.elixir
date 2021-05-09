defmodule MicroLog.LoginTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  def fixture(:user) do
    {:ok, user} =
      MicroLog.Accounts.create_user(%{
        email: "user@example.org",
        name: "test user name",
        password: "password",
        password_confirmation: "password"
      })

    user
  end

  feature "form has fields", %{session: session} do
    session
    |> visit("/login")
    |> refute_has(Query.text("Please login to access this page"))
    |> assert_has(Query.fillable_field("email"))
    |> assert_has(Query.fillable_field("password"))
    |> assert_has(Query.button("Log in"))
    |> refute_has(Query.button("Logout"))
  end

  feature "submitting blank form shows error", %{session: session} do
    session
    |> visit("/login")
    |> click(Query.button("Log in"))
    |> assert_has(Query.text("Invalid email/password combination."))
    |> refute_has(Query.button("Logout"))
  end

  feature "submitting invalid email & password", %{session: session} do
    session
    |> visit("/login")
    |> fill_in(Query.text_field("email"), with: "nonexitant@example.org")
    |> fill_in(Query.text_field("password"), with: "password")
    |> click(Query.button("Log in"))
    |> assert_has(Query.text("Invalid email/password combination."))
    |> refute_has(Query.button("Logout"))
  end

  feature "submitting valid email & password", %{session: session} do
    user = fixture(:user)

    session
    |> visit("/login")
    |> fill_in(Query.text_field("email"), with: user.email)
    |> fill_in(Query.text_field("password"), with: "password")
    |> click(Query.button("Log in"))
    |> refute_has(Query.text("Invalid email/password combination."))
    |> assert_has(Query.text("Welcome back!"))
    |> assert_has(Query.button("Logout"))
  end

  feature "logout logs user out", %{session: session} do
    user = fixture(:user)

    session
    |> login(user)
    |> click(Query.button("Logout"))
    |> refute_has(Query.button("Logout"))
    |> assert_has(Query.link("Login"))
  end

  def login(session, user) do
    session
    |> visit("/login")
    |> fill_in(Query.fillable_field("email"), with: user.email)
    |> fill_in(Query.fillable_field("password"), with: "password")
    |> click(Query.button("Log in"))
  end
end
