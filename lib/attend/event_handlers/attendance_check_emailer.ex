defmodule Attend.EventHandlers.AtendanceCheckEmailer do
  use Commanded.Event.Handler, name: __MODULE__

  alias Attend.Repo
  alias Attend.Projections.Game

  alias Attend.Events.{
    GameScheduled,
    AttendanceRequested
  }

  def handle(%GameScheduled{} = event, _metadta) do
    %Game{
      id: event.game_id,
      team_id: event.team_id,
      start_time: NaiveDateTime.from_iso8601!(event.start_time),
      location: event.location
    }
    |> Repo.insert()

    :ok
  end

  def handle(%AttendanceRequested{} = event, _metadta) do
    game = Repo.get!(Game, event.game_id)

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
