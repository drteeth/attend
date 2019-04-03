defmodule Attend.Attendance do
  alias Attend.CommandRouter
  alias Attend.Attendance.CheckAttendance
  alias Ecto.UUID

  def check_attendance(game_id, team_id) do
    check_id = UUID.generate()

    cmd = %CheckAttendance{
      check_id: check_id,
      game_id: game_id,
      team_id: team_id,
    }

    case CommandRouter.dispatch(cmd) do
      :ok ->
        {:ok, check_id}

      error ->
        error
    end
  end
end