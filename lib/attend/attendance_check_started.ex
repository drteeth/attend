defmodule Attend.Attendance.AttendanceCheckStarted do
  @derive Jason.Encoder
  defstruct [:check_id, :game_id, :team_id]
end