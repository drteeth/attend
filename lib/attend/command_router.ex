defmodule Attend.CommandRouter do
  use Commanded.Commands.Router

  alias Attend.{Team, RegisterTeam}

  alias Attend.Scheduling.Commands.SchedulePickupGame
  alias Attend.Scheduling.Aggregates.Game
  alias Attend.Attendance.{AttendanceCheck, CheckAttendance}

  identify(Team, by: :team_id)
  dispatch([RegisterTeam, Team.AddPlayerToTeam], to: Team)

  identify(Game, by: :game_id)
  dispatch([SchedulePickupGame, CheckAttendance], to: Game)

  identify(AttendanceCheck, by: :check_id)
  dispatch([], to: AttendanceCheck)
end
