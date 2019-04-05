defmodule Attend.Aggregates.AttendanceCheck do
  defstruct [:check_id, status: :initialized]

  alias __MODULE__, as: Check
  alias Attend.Commands.AskPlayerForAttendance
  alias Attend.Events.PlayerAskedForAttendance

  def execute(%Check{}, %AskPlayerForAttendance{} = command) do
    %PlayerAskedForAttendance{
      player_check_id: command.player_check_id,
      check_id: command.check_id,
      game_id: command.game_id,
      team_id: command.team_id,
      player: command.player,
      yes_token: command.yes_token,
      no_token: command.no_token,
      maybe_token: command.maybe_token
    }
  end

  def apply(%Check{}, %PlayerAskedForAttendance{} = event) do
    %Check{check_id: event.player_check_id, status: :started}
  end
end
