defmodule Attend.ProcessManagers.AttendanceCheckManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: __MODULE__,
    router: Attend.CommandRouter

  @derive Jason.Encoder
  defstruct [:check_id, player_checks: []]

  alias __MODULE__, as: State

  alias Attend.Events.{AttendanceCheckStarted, GameEnded}
  alias Attend.Commands.{RequestAttendance, CloseAttendanceCheck}

  def interested?(%AttendanceCheckStarted{} = event) do
    {:start, event.game_id}
  end

  def interested?(%GameEnded{} = event) do
    {:continue, event.game_id}
  end

  def interested?, do: false

  def handle(%State{} = _state, %AttendanceCheckStarted{} = event) do
    event.players
    |> Enum.map(fn player ->
      %RequestAttendance{
        player_check_id: player.player_check_id,
        check_id: event.check_id,
        game_id: event.game_id,
        team: event.team,
        player: player
      }
    end)
  end

  def handle(%State{} = state, %GameEnded{}) do
    state.player_checks
    |> Enum.map(fn player_check_id ->
      %CloseAttendanceCheck{
        player_check_id: player_check_id,
        check_id: state.check_id
      }
    end)
  end

  def apply(%State{} = state, %AttendanceCheckStarted{} = event) do
    player_checks =
      event.players
      |> Enum.map(fn player ->
        player.player_check_id
      end)

    %{state | check_id: event.check_id, player_checks: player_checks}
  end
end
