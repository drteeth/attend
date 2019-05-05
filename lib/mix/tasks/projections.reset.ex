defmodule Mix.Tasks.Projections.Reset do
  def run(_args) do
    config = Application.get_env(:attend, :redis_read_db)
    {:ok, redis} = Redix.start_link(config)

    Redix.command!(redis, ["FLUSHDB"])
  end
end
