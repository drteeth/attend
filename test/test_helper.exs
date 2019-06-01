ExUnit.configure(exclude: [:pending])
ExUnit.start()

defmodule TestHelper do
  import Commanded.Assertions.EventAssertions

  alias Attend.Events.TeamRegistered
  alias Attend.Events.JoinedTeam
  alias Attend.Events.GameScheduled
  alias Attend.Events.GameCancelled

  def register_team(name \\ "The Noodles") do
    {:ok, team_id} = Attend.register_team(name)
    wait_for_event(TeamRegistered)
    team_id
  end

  def add_player(team_id, name, email) do
    {:ok, player_id} = Attend.add_player_to_team(team_id, name, email)
    wait_for_event(JoinedTeam)
    player_id
  end

  def schedule_game(team_id, options) do
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

  def days_from_now(number_of_days) do
    DateTime.add(now(), 60 * 60 * 24 * number_of_days)
  end

  def now() do
    with {:ok, time} <- DateTime.now("Etc/UTC") do
      {:ok, time} = DateTime.from_naive(time, "Etc/UTC")
      time
    end
  end
end
