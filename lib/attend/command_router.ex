defmodule Attend.CommandRouter do
  use Commanded.Commands.Router

  alias Attend.Commands.{
    RegisterTeam,
    CheckAttendance,
    JoinTeam,
    SchedulePickupGame,
    RequestAttendance,
    ConfirmAttendance,
    StartGame,
    EndGame,
    CloseAttendanceCheck
  }

  alias Attend.Aggregates.{
    Team,
    Game,
    AttendanceCheck
  }

  dispatch([RegisterTeam, JoinTeam, CheckAttendance], to: Team, identity: :team_id)

  dispatch([SchedulePickupGame, StartGame, EndGame], to: Game, identity: :game_id)

  dispatch([RequestAttendance, ConfirmAttendance, CloseAttendanceCheck],
    to: AttendanceCheck,
    identity: :player_check_id
  )
end
