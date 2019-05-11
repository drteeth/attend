defmodule Attend.Projections.Game do
  @games "game-index-games"
  @teams "game-index-teams"

  @derive Jason.Encoder
  defstruct [
    :id,
    :location,
    :start_time,
    :team_id,
    :team_name,
    :status
  ]

  alias __MODULE__, as: Game

  @type id :: Ecto.UUID.t()
  @type game :: Game.t()

  @spec put_team_name(id, String.t()) :: :ok
  def put_team_name(id, name) do
    Redix.command!(:redix, ["HSET", @teams, id, name])
    :ok
  end

  @spec get_team_name(id) :: String.t()
  def get_team_name(id) do
    Redix.command!(:redix, ["HGET", @teams, id])
  end

  @spec put(game) :: game
  def put(game) do
    Redix.command!(:redix, ["HSET", @games, game.id, serialize(game)])
    game
  end

  @spec get(id) :: game
  def get(id) do
    Redix.command!(:redix, ["HGET", @games, id])
    |> deserialize()
  end

  @spec all() :: list(game)
  def all() do
    Redix.command!(:redix, ["HGETALL", @games])
    |> Enum.drop_every(2)
    |> Enum.map(&deserialize/1)
  end

  @spec update_status(id, atom) :: :ok
  def update_status(game_id, status) do
    get(game_id)
    |> Map.put(:status, status)
    |> put()
  end

  defp serialize(term) do
    :erlang.term_to_binary(term)
  end

  defp deserialize(str) do
    :erlang.binary_to_term(str)
  end
end
