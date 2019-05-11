defmodule Attend.EventHandlers.AtendanceCheckEmailer do
  use Commanded.Event.Handler, name: __MODULE__

  alias Attend.Events.{
    GameScheduled,
    AttendanceRequested
  }

  defmodule Store do
    @key "attendance-check-emailer-store"

    def put(game) do
      serialized = :erlang.term_to_binary(game)
      Redix.command!(:redix, ["HSET", @key, game.id, serialized])
    end

    def get(game_id) do
      serialized = Redix.command!(:redix, ["HGET", @key, game_id])
      :erlang.binary_to_term(serialized)
    end
  end

  def handle(%GameScheduled{} = event, _metadta) do
    game = %{
      id: event.game_id,
      team_id: event.team_id,
      start_time: NaiveDateTime.from_iso8601!(event.start_time),
      location: event.location
    }

    Store.put(game)

    :ok
  end

  def handle(%AttendanceRequested{} = event, _metadta) do
    game = Store.get(event.game_id)

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
