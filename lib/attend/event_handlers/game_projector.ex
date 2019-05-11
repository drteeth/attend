defmodule Attend.EventHandlers.GameProjector do
  use Commanded.Event.Handler, name: __MODULE__

  alias Attend.Events
  alias Attend.Projections.Game
  alias AttendWeb.Endpoint

  def handle(%Events.TeamRegistered{team_id: id, name: name}, _metadata) do
    Game.put_team_name(id, name)
  end

  def handle(%Events.GameScheduled{} = event, _metadata) do
    {:ok, start_time, _offset} = DateTime.from_iso8601(event.start_time)

    team_name = Game.get_team_name(event.team_id)

    game = %Game{
      id: event.game_id,
      location: event.location,
      start_time: start_time,
      team_id: event.team_id,
      team_name: team_name,
      status: :scheduled
    }

    Game.put(game)
    |> broadcast()

    :ok
  end

  def handle(%Events.GameCancelled{} = event, _metadata) do
    Game.update_status(event.game_id, :cancelled)
    :ok
  end

  def handle(%Events.GameStarted{} = event, _metadata) do
    Game.update_status(event.game_id, :stated)
    :ok
  end

  def handle(%Events.GameEnded{} = event, _metadata) do
    Game.update_status(event.game_id, :ended)
    :ok
  end

  defp broadcast(game) do
    # TODO use a view to render the game
    # resp = View.render_one(game, MessageView, "message_sent.json", %{sent: sent})
    Endpoint.broadcast("games", "joined_game", game)
    Endpoint.broadcast("games:#{game.id}", "joined_game", game)
  end
end
