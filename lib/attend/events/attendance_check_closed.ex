defmodule Attend.Events.AttendanceCheckClosed do
  @derive Jason.Encoder
  defstruct [:check_id, :player_check_id]
end
