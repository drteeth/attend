defmodule Attend.Projections.Team do
  alias __MODULE__, as: Team

  @type id :: UUID.t()
  @type team :: Team.t()
  @type player :: Player.t()

  @key "team-projection"
  @games "games-for-teams"

  @derive Jason.Encoder
  defstruct id: nil, name: nil, players: []

  defmodule Player do
    @derive Jason.Encoder
    defstruct [:id]
  end

  defmodule Game do
    defstruct [:game_id, :location, :start_time, :team_id]
  end

  @spec create_team(team) :: team
  def create_team(team) do
    put_team(team)
  end

  @spec all() :: list(team)
  def all() do
    Redix.command!(:redix, ["HGETALL", @key])
    |> Enum.drop_every(2)
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
  def remove_player(team, player_id) do
    team = get(team.id)
    player = Enum.find(team.players, fn player -> player.id == player_id end)
    updated_players = List.delete(team.players, player)

    Map.put(team, :players, updated_players)
    |> put_team()
  end

  @spec add_game(Game.t()) :: Game.t()
  def add_game(%Game{} = game) do
    # TODO: ZADD for a sorted set?
    serialized = serialize(game)
    Redix.command!(:redix, ["RPUSH", "#{@games}_#{game.team_id}", serialized])
    game
  end

  @spec upcoming_games(id) :: list(Game.t())
  def upcoming_games(team_id) do
    # TODO only upcoming_games
    Redix.command!(:redix, ["LRANGE", "#{@games}_#{team_id}", 0, -1])
    |> Enum.map(&deserialize/1)
    |> IO.inspect()
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
