defmodule MicroLog.Repo.Migrations.AddAdminFlagToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add_if_not_exists :admin, :boolean, default: false
    end
  end
end
