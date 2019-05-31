defmodule Attend.EventHandlers.TeamProjector do
  use Commanded.Event.Handler, name: __MODULE__

  alias Attend.Events
  alias AttendWeb.Endpoint
  alias Attend.Projections.Team
  alias Attend.Projections.Team.Game

  def handle(%Events.TeamRegistered{} = event, _metadata) do
    team = %Team{
      id: event.team_id,
      name: event.name,
      players: []
    }

    team
    |> Team.create_team()
    |> broadcast("team_registered")

    :ok
  end

  def handle(%Events.JoinedTeam{} = event, _metadata) do
    Team.get(event.team_id)
    |> Team.add_player(event.player)
    |> broadcast("joined_team")

    :ok
  end

  def handle(%Events.LeftTeam{} = event, _metadata) do
    Team.get(event.team_id)
    |> Team.remove_player(event.player_id)
    |> broadcast("left_team")

    :ok
  end

  def handle(%Events.GameScheduled{} = event, _metadata) do
    Team.add_game(%Game{
      game_id: event.game_id,
      location: event.location,
      start_time: event.start_time,
      team_id: event.team_id
    })
    |> broadcast("game_scheduled")

    :ok
  end

  def handle(%Events.GameCancelled{} = _event, _metadata) do
    # TODO...
    :ok
  end

  def handle(%Events.GameEnded{} = _event, _metadata) do
    # TODO...
    :ok
  end

  defp broadcast(%Team{} = team, event) do
    # TODO use a view to render the team
    # resp = View.render_one(team, MessageView, "message_sent.json", %{sent: sent})
    Endpoint.broadcast("teams", event, team)
    Endpoint.broadcast("teams:#{team.id}", event, team)
  end

  defp broadcast(%Game{} = game, event) do
    # TODO use a view to render the team
    # resp = View.render_one(team, MessageView, "message_sent.json", %{sent: sent})
    Endpoint.broadcast("games", event, game)
    Endpoint.broadcast("games:#{game.game_id}", event, game)
  end
end
