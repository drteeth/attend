defmodule Attend.Commands.SchedulePickupGame do
  @derive Jason.Encoder
  defstruct [:game_id, :team_id, :location, :start_time]
end
