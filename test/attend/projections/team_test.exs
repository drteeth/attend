defmodule Attend.Projections.TeamTest do
  use Attend.DataCase

  alias Attend.Projections.Team

  test ".all contains registered teams" do
    noodles_id = register_team("The Noodles")
    bears_id = register_team("The Bears")

    assert [bears_id, noodles_id] == Team.all() |> Enum.map(fn t -> t.id end)
  end

  test ".get retrieves a team" do
    team_id = register_team("The Noodles")
    player_id = add_player(team_id, "Alice", "alice@example.com")

    team = Team.get(team_id)

    assert team.id == team_id
    assert team.name == "The Noodles"

    [player] = team.players
    assert player.id == player_id
    assert player.name == "Alice"
    assert player.email == "alice@example.com"
  end

  describe ".upcoming games" do
    test "orders games by nearest to furthest" do
      team_id = register_team()

      g2 = schedule_game(team_id, start_time: days_from_now(2))
      g3 = schedule_game(team_id, start_time: days_from_now(3))
      g1 = schedule_game(team_id, start_time: days_from_now(1))

      games = Team.upcoming_games(team_id)

      [
        %{game_id: ^g1},
        %{game_id: ^g2},
        %{game_id: ^g3}
      ] = games
    end

    test "only includes games in the future" do
      team_id = register_team()
      _old = schedule_game(team_id, start_time: ~N[2010-05-12 21:30:00])
      upcoming = schedule_game(team_id, start_time: days_from_now(10))

      [game] = Team.upcoming_games(team_id)
      assert game.game_id == upcoming
    end

    test "does not include cancelled games" do
      team_id = register_team()
      game_id = schedule_game(team_id, start_time: ~N[2010-05-12 21:30:00])
      cancel_game(game_id)

      assert Team.upcoming_games(team_id) == []
    end
  end

end
