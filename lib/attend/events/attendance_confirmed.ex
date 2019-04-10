defmodule Attend.Events.AttendanceConfirmed do
  @derive Jason.Encoder
  defstruct [:player_check_id, :check_id, :response_token_id, :response, :message]
end
