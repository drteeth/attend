defmodule Attend.EventHandlers.AtendanceCheckEmailer do
  use Commanded.Event.Handler, name: __MODULE__

  alias Attend.Events.{
    GameScheduled,
    AttendanceCheckStarted,
    PlayerAskedForAttendance,
  }

  def handle(%GameScheduled{} = event, _metadta) do
    # Bare event handler doesn't have state so either
    # A) Make this a ProcessManager keyed on GameScheduled
    # B) Project Team roster into the DB and read from that before sending the email
    IO.inspect(event)
    :ok
  end

  def handle(%AttendanceCheckStarted{} = event, _metadta) do
    IO.inspect(event)
    :ok
  end

  def handle(%PlayerAskedForAttendance{} = event, _metadta) do
    IO.inspect(event)
    :ok
  end

end
