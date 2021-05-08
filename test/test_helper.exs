ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MicroLog.Repo, :manual)
Application.put_env(:wallaby, :base_url, "http://localhost:4000")
{:ok, _} = Application.ensure_all_started(:wallaby)
