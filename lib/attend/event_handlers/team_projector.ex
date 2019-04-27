defmodule Attend.EventHandlers.TeamProjector do
  use Commanded.Projections.Ecto, name: __MODULE__

  alias Attend.Events
  alias Attend.Projections
  alias Attend.Repo

  alias AttendWeb.Endpoint

  def handle(%Events.TeamRegistered{} = event, _metadata) do
    team = %Projections.Team{
      id: event.team_id,
      name: event.name
    }

    team = Repo.insert!(team)

    # TODO use a view to render the team
    # resp = View.render_one(team, MessageView, "message_sent.json", %{sent: sent})
    Endpoint.broadcast("teams", "team_registered", Map.from_struct(team))
    Endpoint.broadcast("team:#{team.id}", "team_registered", Map.from_struct(team))
  end

  def handle(%Events.JoinedTeam{} = event, _metadata) do
    team = Repo.get!(Projections.Team, event.team_id)

    existing_players =
      team.players
      |> Enum.map(&Map.from_struct/1)

    players = existing_players ++ [event.player]

    team =
      team
      |> Projections.Team.changeset(%{players: players})
      |> Repo.update!()

    payload = Map.from_struct(team)
    Endpoint.broadcast("teams", "joined_team", payload)
    Endpoint.broadcast("teams:#{team.id}", "joined_team", payload)
    :ok
  end

  def handle(%Events.LeftTeam{} = event, _metadata) do
    team = Repo.get!(Projections.Team, event.team_id)

    existing_players =
      team.players
      |> Enum.map(&Map.from_struct/1)

    player = Enum.find(existing_players, fn p -> p.id == event.player_id end)

    players = List.delete(existing_players, player)

    team =
      team
      |> Projections.Team.changeset(%{players: players})
      |> Repo.update!()

    payload = Map.from_struct(team)
    Endpoint.broadcast("teams", "joined_team", payload)
    Endpoint.broadcast("teams:#{team.id}", "joined_team", payload)
    :ok
  end
end
