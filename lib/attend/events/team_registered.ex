defmodule Attend.Events.TeamRegistered do
  @derive Jason.Encoder
  defstruct [:team_id, :name]
end
