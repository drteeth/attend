defmodule Attend.Projections.Team.Show do
  @type id :: UUID.t()
  @type team :: map()
  @type player :: map()

  @key "teams-show-teams"

  @spec create_team(team) :: team
  def create_team(team) do
    put_team(team)
  end

  @spec get(id) :: team
  def get(team_id) do
    Redix.command!(:redix, ["HGET", @key, team_id])
    |> Jason.decode!()
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end

  @spec add_player(team, player) :: team
  def add_player(team, player) do
    team = get(team.id)
    updated_players = team.players ++ [player]

    Map.put(team, :players, updated_players)
    |> put_team()
  end

  @spec remove_player(team, id) :: team
  def remove_player(team, _player_id) do
    team
  end

  @spec put_team(team) :: team
  defp put_team(team) do
    Redix.command!(:redix, ["HSET", @key, team.id, Jason.encode!(team)])
    team
  end
end
