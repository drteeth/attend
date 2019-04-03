defmodule Mix.Tasks.Attend.Sample do
  def run(_args) do
    Mix.Task.run("app.start")

    {:ok, team_id} = Attend.register_team("The Noodles")

    {:ok, _player_id} = Attend.add_player_to_team(team_id, "Ben", "ben@example.com")

    {:ok, game_id} =
      Attend.schedule_pickup_game(team_id, "Monarch Park - Field 4", ~N[2019-12-12 21:30:00])

    {:ok, _check_id} = Attend.check_attendance(game_id, team_id)
  end
end
