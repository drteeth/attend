defmodule Attend.Attendance.Checker do
  use Commanded.ProcessManagers.ProcessManager,
      name: __MODULE__,
      router: CommandRouter


  @derive Jason.Encoder
  defstruct []

  # def interested?(%MoneyTransferRequested{transfer_uuid: transfer_uuid}), do: {:start, transfer_uuid}
  # def interested?(%MoneyWithdrawn{transfer_uuid: transfer_uuid}), do: {:continue, transfer_uuid}
  # def interested?(%MoneyDeposited{transfer_uuid: transfer_uuid}), do: {:stop, transfer_uuid}
  def interested?(%Attendance)
  def interested?(_event), do: false
end