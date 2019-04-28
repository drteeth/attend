defmodule Attend.EventHandlers.GameProjector do
  use Commanded.Projections.Ecto, name: __MODULE__

  alias Attend.Events
  alias Attend.Projections.Game.Index
  alias AttendWeb.Endpoint

  def handle(%Events.TeamRegistered{team_id: id, name: name}, _metadata) do
    Index.put_team(id, name)
    :ok
  end

  def handle(%Events.GameScheduled{} = event, _metadata) do
    {:ok, start_time, _offset} = DateTime.from_iso8601(event.start_time)

    game = %{
      id: event.game_id,
      location: event.location,
      start_time: start_time,
      team: %{
        id: event.team_id,
        name: Index.get_team_name(event.team_id)
      }
    }

    game
    |> Index.put()
    |> broadcast()

    :ok
  end

  # TODO handle cancel, end, etc

  defp broadcast(game) do
    # TODO use a view to render the game
    # resp = View.render_one(game, MessageView, "message_sent.json", %{sent: sent})
    Endpoint.broadcast("games", "joined_game", game)
    Endpoint.broadcast("games:#{game.id}", "joined_game", game)
  end
end
