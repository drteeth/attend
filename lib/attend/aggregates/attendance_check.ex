defmodule Attend.Aggregates.AttendanceCheck do
  defstruct [:player_check_id, :status, :check_id, tokens: %{}]

  alias __MODULE__
  alias Attend.Commands.{RequestAttendance, ConfirmAttendance, CloseAttendanceCheck}
  alias Attend.Events.{AttendanceRequested, AttendanceConfirmed, AttendanceCheckClosed}

  def execute(%AttendanceCheck{player_check_id: nil}, %RequestAttendance{} = command) do
    %AttendanceRequested{
      player_check_id: command.player_check_id,
      check_id: command.check_id,
      game_id: command.game_id,
      team: command.team,
      player: command.player
    }
  end

  def execute(%AttendanceCheck{} = check, %ConfirmAttendance{} = command) do
    response = check.tokens[command.response_token_id]

    if(check.status != :closed) do
      %AttendanceConfirmed{
        player_check_id: command.player_check_id,
        check_id: check.check_id,
        response_token_id: command.response_token_id,
        response: response,
        message: command.message
      }
    else
      {:error, :check_closed}
    end
  end

  def execute(%AttendanceCheck{} = check, %CloseAttendanceCheck{}) do
    %AttendanceCheckClosed{
      player_check_id: check.player_check_id,
      check_id: check.check_id
    }
  end

  def apply(%AttendanceCheck{} = check, %AttendanceRequested{} = event) do
    %{
      check
      | player_check_id: event.player_check_id,
        status: :started,
        check_id: event.check_id,
        tokens: %{
          event.yes_token => :yes,
          event.no_token => :no,
          event.maybe_token => :maybe
        }
    }
  end

  def apply(%AttendanceCheck{} = check, %AttendanceConfirmed{}) do
    %{check | status: :confirmed}
  end

  def apply(%AttendanceCheck{} = check, %AttendanceCheckClosed{}) do
    %{check | status: :closed}
  end
end
