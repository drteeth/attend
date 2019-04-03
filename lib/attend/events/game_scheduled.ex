defmodule Attend.Events.GameScheduled do
  @derive Jason.Encoder
  defstruct [:game_id, :team_id, :location, :start_time]
end
