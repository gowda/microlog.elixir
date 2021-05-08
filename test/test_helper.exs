ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MicroLog.Repo, :manual)
Application.put_env(:wallaby, :base_url, MicroLogWeb.Endpoint.url())
{:ok, _} = Application.ensure_all_started(:wallaby)
