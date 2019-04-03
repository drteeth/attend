defmodule Attend.Events.PlayerAddedToTeam do
  @derive Jason.Encoder
  @enforce_keys [:team_id, :player]
  defstruct @enforce_keys
end
