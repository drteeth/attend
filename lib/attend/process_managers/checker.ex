defmodule Attend.ProcessManagers.Checker do
  use Commanded.ProcessManagers.ProcessManager,
    name: __MODULE__,
    router: Attend.CommandRouter

  @derive Jason.Encoder
  defstruct checks: %{}

  alias __MODULE__, as: State

  alias Attend.Events.AttendanceCheckStarted
  alias Attend.Commands.AskPlayerForAttendance

  def interested?(%AttendanceCheckStarted{} = event) do
    {:start, event.check_id}
  end
  def interested?(_event), do: false

  def handle(%State{} = _state, %AttendanceCheckStarted{} = event) do
    event.players
    |> Enum.map(fn player ->
      %AskPlayerForAttendance{
        player_check_id: player.player_check_id,
        check_id: event.check_id,
        game_id: event.game_id,
        team: event.team,
        player: player
      }
    end)
  end
end
