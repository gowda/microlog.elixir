defmodule MicroLog.UserSignupTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature
  # use Wallaby.DSL

  feature "signup form has fields", %{session: session} do
    session
    |> visit("/")
    |> click(Query.link("Sign up now!"))
    |> assert_has(Query.fillable_field("user[name]"))
    |> assert_has(Query.fillable_field("user[email]"))
    |> assert_has(Query.fillable_field("user[password]"))
    |> assert_has(Query.fillable_field("user[password_confirmation]"))
    |> assert_has(Query.button("Create my account"))
  end

  feature "submitting blank signup form shows errors", %{session: session} do
    session
    |> visit("/signup")
    |> click(Query.button("Create my account"))
    |> assert_has(Query.text("Oops, something went wrong! Please check the errors below."))
    |> assert_has(Query.text("Name can't be blank"))
    |> assert_has(Query.text("Email can't be blank"))
    |> assert_has(Query.text("Password can't be blank"))
  end

  feature "submitting signup form with invalid email", %{session: session} do
    session
    |> visit("/signup")
    |> fill_in(Query.text_field("user_email"), with: "invalid.email")
    |> click(Query.button("Create my account"))
    |> assert_has(Query.text("Oops, something went wrong! Please check the errors below."))
    |> assert_has(Query.text("Email has invalid format"))
  end
end
