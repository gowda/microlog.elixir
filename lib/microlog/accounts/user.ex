defmodule MicroLog.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :password_digest, :string, redact: true

    timestamps()
  end

  @doc false
  def changeset_for_update(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_change(:email, fn _, _ -> [email: "cannot be updated"] end)
    |> validate_required([:name])
  end

  @doc false
  def changeset_for_create(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
    |> unique_constraint(:email)
    |> validate_confirmation(:password, message: "does not match password")
    |> generate_password_digest()
  end

  @doc false
  defp generate_password_digest(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        changeset
        |> put_change(:password_digest, digest(password))
        |> put_change(:password, nil)

      _ ->
        changeset
    end
  end

  @doc false
  def digest(string) do
    :crypto.hash(:sha256, string)
    |> Base.encode16()
    |> String.downcase()
  end
end
