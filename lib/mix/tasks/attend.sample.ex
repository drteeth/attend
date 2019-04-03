defmodule Mix.Tasks.Attend.Sample do
  alias Attend.{Registration, Scheduling, Attendance}

  def run(_args) do
    Mix.Task.run("app.start")

    {:ok, team_id} = Registration.register_team("The Noodles")

    {:ok, player_id} = Registration.add_player_to_team(team_id, "Ben", "ben@example.com")

    {:ok, game_id} =
      Scheduling.schedule_pickup_game(team_id, "Monarch Park - Field 4", ~N[2019-12-12 21:30:00])

    {:ok, check_id} = Attendance.check_attendance(game_id, team_id)
  end
end
