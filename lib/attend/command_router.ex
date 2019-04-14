defmodule Attend.CommandRouter do
  use Commanded.Commands.Router

  alias Attend.Commands

  alias Attend.Aggregates.{
    Team,
    Game,
    AttendanceCheck
  }

  dispatch(
    [
      Commands.RegisterTeam,
      Commands.JoinTeam,
      Commands.RequestTeamAttendance
    ],
    to: Team,
    identity: :team_id
  )

  dispatch(
    [
      Commands.SchedulePickupGame,
      Commands.CheckAttendance,
      Commands.StartGame,
      Commands.CancelGame,
      Commands.EndGame
    ],
    to: Game,
    identity: :game_id
  )

  dispatch(
    [
      Commands.RequestAttendance,
      Commands.ConfirmAttendance,
      Commands.CloseAttendanceCheck
    ],
    to: AttendanceCheck,
    identity: :player_check_id
  )
end
