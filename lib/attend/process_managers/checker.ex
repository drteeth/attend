defmodule Attend.ProcessManagers.Checker do
  use Commanded.ProcessManagers.ProcessManager,
    name: __MODULE__,
    router: Attend.CommandRouter

  @derive Jason.Encoder
  defstruct []

  alias __MODULE__, as: State
  alias Attend.Events.{AttendanceCheckStarted, PlayerAskedForAttendance}
  alias Attend.Commands.{AskPlayerForAttendance}

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
    event.players
    |> Enum.map(fn player ->
      # TODO consider also creating IDs/Token values for yes/no/maybe here?
      # TODO: why not just send the email here? qq
      #   +> Answer: cuz we don't have the data. (team name, game location, player email, etc)
      # And that has to be listen for by an Event Handler
      %AskPlayerForAttendance{
        check_id: event.check_id,
        game_id: event.game_id,
        team_id: event.team_id,
        player: player
      }
    end)
  end

  def handle(%State{} = state, %PlayerAskedForAttendance{} = event) do
    # Send an email?
    # Start a timeout?
  end

  def apply(%State{} = state, %AttendanceCheckStarted{} = event) do
    # remember(the(check_id, game_id, team_id, players(ids)))
    # setup a(map(to(listen(for completes))))
    # setup timers(to(timeout(the(requests))))
    state
  end

  def apply(%State{} = state, %PlayerAskedForAttendance{} = event) do
    # TODO: mark that we've started the check for this player and are awaiting a reply.
    # TODO: consider
    state
  end
end
