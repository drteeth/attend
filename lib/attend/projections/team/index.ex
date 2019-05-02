defmodule Attend.Projections.Team.Index do
  @type team :: map()
  @teams "team-index-teams"

  @spec create_team(team) :: team
  def create_team(team) do
    Redix.command!(:redix, ["RPUSH", @teams, Jason.encode!(team)])
    team
  end

  @spec all() :: list(team)
  def all() do
    Redix.command!(:redix, ["LRANGE", @teams, 0, -1])
    |> Enum.map(fn str ->
      Jason.decode!(str)
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    end)
  end
end
