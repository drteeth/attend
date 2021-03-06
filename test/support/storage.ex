defmodule Attend.Storage do
  def reset! do
    reset_eventstore()
    reset_readstore()
  end

  defp reset_eventstore() do
    config =
      EventStore.Config.parsed()
      |> EventStore.Config.default_postgrex_opts()

    {:ok, conn} = Postgrex.start_link(config)

    EventStore.Storage.Initializer.reset!(conn)
  end

  defp reset_readstore() do
    config = Application.get_env(:attend, Attend.Repo)

    {:ok, conn} = Postgrex.start_link(config)
    Postgrex.query!(conn, truncate_readstore_tables(), [])

    redis_config = Application.get_env(:attend, :redis_read_db)
    {:ok, redis} = Redix.start_link(redis_config)
    Redix.command!(redis, ["FLUSHDB"])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
    projection_versions
    RESTART IDENTITY
    CASCADE;
    """
  end
end
