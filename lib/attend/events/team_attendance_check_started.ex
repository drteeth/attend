defmodule Attend.Events.TeamAttendanceCheckStarted do
  @derive Jason.Encoder
  defstruct [:check_id, :game_id, :team, :players]
end
