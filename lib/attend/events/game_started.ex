defmodule Attend.Events.GameStarted do
  @derive Jason.Encoder
  defstruct [
    :game_id,
    :location,
    :team_id,
    :start_time,
    :started_at
  ]
end
