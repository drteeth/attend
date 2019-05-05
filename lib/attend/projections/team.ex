defmodule Attend.Projections.Team do
  alias __MODULE__, as: Team

  @type id :: UUID.t()
  @type team :: Team.t()
  @type player :: Player.t()

  @key "team-projection"

  @derive Jason.Encoder
  defstruct id: nil, name: nil, players: []

  defmodule Player do
    @derive Jason.Encoder
    defstruct [:id]
  end

  @spec create_team(team) :: team
  def create_team(team) do
    put_team(team)
  end

  @spec all() :: list(team)
  def all() do
    Redix.command!(:redix, ["HGETALL", @key])
    |> IO.inspect()
    |> Enum.drop_every(2)
    |> IO.inspect()
    |> Enum.map(&deserialize/1)
  end

  @spec get(id) :: team
  def get(team_id) do
    Redix.command!(:redix, ["HGET", @key, team_id])
    |> deserialize()
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
    # TODO actually remove the player...
    team
    |> IO.inspect(label: "team#remove_player()")
  end

  @spec put_team(team) :: team
  defp put_team(team) do
    Redix.command!(:redix, ["HSET", @key, team.id, serialize(team)])
    team
  end

  defp serialize(term) do
    :erlang.term_to_binary(term)
  end

  defp deserialize(str) do
    :erlang.binary_to_term(str)
  end

end
