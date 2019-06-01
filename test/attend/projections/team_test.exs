defmodule Attend.Projections.TeamTest do
  use Attend.DataCase

  alias Attend.Projections.Team
  alias Attend.Events.TeamRegistered
  alias Attend.Events.JoinedTeam
  alias Attend.Events.GameScheduled
  alias Attend.Events.GameCancelled

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

  defp register_team(name \\ "The Noodles") do
    {:ok, team_id} = Attend.register_team(name)
    wait_for_event(TeamRegistered)
    team_id
  end

  defp add_player(team_id, name, email) do
    {:ok, player_id} = Attend.add_player_to_team(team_id, name, email)
    wait_for_event(JoinedTeam)
    player_id
  end

  defp schedule_game(team_id, options) do
    location = Keyword.get(options, :location, "Test Park")

    start_time =
      Keyword.get(options, :start_time, now())
      |> DateTime.from_naive!("Etc/UTC")

    {:ok, game_id} = Attend.schedule_pickup_game(team_id, location, start_time)
    wait_for_event(GameScheduled)
    game_id
  end

  def cancel_game(game_id) do
    :ok = Attend.cancel_game(game_id)
    wait_for_event(GameCancelled)
  end

  defp days_from_now(number_of_days) do
    DateTime.add(now(), 60 * 60 * 24 * number_of_days)
  end

  defp now() do
    with {:ok, time} <- DateTime.now("Etc/UTC") do
      {:ok, time} = DateTime.from_naive(time, "Etc/UTC")
      time
    end
  end
end
