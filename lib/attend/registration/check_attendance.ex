defmodule Attend.Attendance.CheckAttendance do
  @derive Jason.Encoder
  defstruct [:check_id, :game_id, :team_id]
end