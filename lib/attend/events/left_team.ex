defmodule Attend.Events.LeftTeam do
  @derive Jason.Encoder
  defstruct [:team_id, :player_id]
end
