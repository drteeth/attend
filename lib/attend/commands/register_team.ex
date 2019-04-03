defmodule Attend.Commands.RegisterTeam do
  @enforce_keys [:team_id, :name]
  defstruct @enforce_keys
end
