defmodule MicroLog.Repo do
  use Ecto.Repo,
    otp_app: :microlog,
    adapter: Ecto.Adapters.Postgres
end
