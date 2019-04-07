defmodule Attend.CommandRouter do
  use Commanded.Commands.Router

  alias Attend.Commands.{
    RegisterTeam,
    CheckAttendance,
    AddPlayerToTeam,
    SchedulePickupGame,
    AskPlayerForAttendance,
    ConfirmAttendance
  }

  alias Attend.Aggregates.{
    Team,
    Game,
    AttendanceCheck
  }

  dispatch([RegisterTeam, AddPlayerToTeam, CheckAttendance], to: Team, identity: :team_id)

  dispatch(SchedulePickupGame, to: Game, identity: :game_id)

  dispatch([AskPlayerForAttendance, ConfirmAttendance],
    to: AttendanceCheck,
    identity: :player_check_id
  )
end
