defmodule Attend.ProcessManagers.Checker do
  use Commanded.ProcessManagers.ProcessManager,
    name: __MODULE__,
    router: CommandRouter

  @derive Jason.Encoder
  defstruct []

  alias __MODULE__, as: State
  alias Attend.Events.AttendanceCheckStarted

  # def interested?(%MoneyTransferRequested{transfer_uuid: transfer_uuid}), do: {:start, transfer_uuid}
  # def interested?(%MoneyWithdrawn{transfer_uuid: transfer_uuid}), do: {:continue, transfer_uuid}
  # def interested?(%MoneyDeposited{transfer_uuid: transfer_uuid}), do: {:stop, transfer_uuid}
  # def interested?(%Attendance) do
  #   false
  # end

  # check_id: command.check_id,
  #   game_id: command.game_id,
  #   team_id: command.team_id,
  #   players: team.players
  def interested?(%AttendanceCheckStarted{} = event) do
    {:start, event.check_id}
  end
  def interested?(_event), do: false

  def handle(%State{} = state, %AttendanceCheckStarted{} = event) do
    []
  end

  def apply(%State{} = state, %AttendanceCheckStarted{} = event) do
    state
  end
end
