defmodule Attend.Events.PlayerAskedForAttendance do
  @derive Jason.Encoder
  defstruct [
    :player_check_id,
    :check_id,
    :game_id,
    :team_id,
    :player,
    :yes_token,
    :no_token,
    :maybe_token,
  ]
end
