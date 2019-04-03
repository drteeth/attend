defmodule Attend.CommandRouter do
  use Commanded.Commands.Router

  alias Attend.Commands.{
    RegisterTeam,
    CheckAttendance,
    AddPlayerToTeam,
    SchedulePickupGame
  }

  alias Attend.Aggregates.{
    Team,
    Game,
    AttendanceCheck
  }

  identify(Team, by: :team_id)
  dispatch([RegisterTeam, AddPlayerToTeam], to: Team)

  identify(Game, by: :game_id)
  dispatch([SchedulePickupGame, CheckAttendance], to: Game)

  identify(AttendanceCheck, by: :check_id)
  dispatch([], to: AttendanceCheck)
end
