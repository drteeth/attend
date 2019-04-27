defmodule Attend.EventHandlers.AtendanceCheckEmailer do
  use Commanded.Event.Handler, name: __MODULE__

  alias Attend.Events.{
    GameScheduled,
    AttendanceRequested
  }

  @table :game_projection

  def init() do
    :ets.new(@table, [:named_table])
    :ok
  end

  def handle(%GameScheduled{} = event, _metadta) do
    game = %{
      id: event.game_id,
      team_id: event.team_id,
      start_time: NaiveDateTime.from_iso8601!(event.start_time),
      location: event.location
    }

    :ets.insert(@table, {game.id, game})

    :ok
  end

  def handle(%AttendanceRequested{} = event, _metadta) do
    [{_, game}] = :ets.lookup(@table, event.game_id)

    Attend.Email.attendance_check(
      event.player_check_id,
      event.team,
      game,
      event.player,
      Map.take(event, [:yes_token, :no_token, :maybe_token])
    )
    |> Attend.Email.Mailer.deliver_later()

    :ok
  end

end
