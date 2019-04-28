defmodule Attend.Projections.Game.Index do
  @games "game-index-games"
  @teams "game-index-teams"

  def put_team(id, name) do
    Redix.command! :redix, ["HSET", @teams, id, name]
  end

  def get_team_name(id) do
    Redix.command! :redix, ["HGET", @teams, id]
  end

  def put(game) do
    Redix.command!(:redix, ["HSET", @games, game.id, Jason.encode!(game)])
    IO.inspect(game)
    game
  end

  def get(id) do
    Redix.command!(:redix, ["HGET", @games, id])
    |> Jason.decode!()
  end

  def all() do
    Redix.command!(:redix, ["HGETALL", @games])
    |> Enum.drop_every(2)
    |> Enum.map(&Jason.decode!/1)
  end
end
