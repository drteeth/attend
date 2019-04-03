defmodule Attend.Events.AttendanceCheckStarted do
  @derive Jason.Encoder
  defstruct [:check_id, :game_id, :team_id, :players]
end
