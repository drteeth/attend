defmodule Attend.Events.JoinedTeam do
  @derive Jason.Encoder
  @enforce_keys [:team_id, :player]
  defstruct @enforce_keys
end
