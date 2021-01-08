defmodule MicroLog.Repo.Migrations.AddPasswordDigestToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add_if_not_exists :password_digest, :string, null: false
    end
  end
end
