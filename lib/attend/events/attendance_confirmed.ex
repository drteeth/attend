defmodule Attend.Events.AttendanceConfirmed do
  @derive Jason.Encoder
  # TODO: reason
  defstruct [:player_check_id, :check_id, :response_token_id, :response]
end
