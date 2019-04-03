defmodule AttendWeb.Team.Form do
  use Phoenix.LiveView

  alias Attend.Models.{Player, Team}

  @impl true
  def mount(%{team_id: team_id}, socket) do
    team = %Team{team_id: team_id}
    changeset = Team.changeset(team, %{name: "The Noodles"})

    player =
      Player.changeset(%Player{}, %{
        name: "Bob Ross",
        email: "bob@example.com"
      })

    socket =
      assign(socket,
        team: team,
        changeset: changeset,
        new_player: player
      )

    case EventStore.subscribe(team_id, mapper: fn e -> e.data end) do
      :ok ->
        {:ok, socket}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl true
  def render(assigns) do
    AttendWeb.TeamView.render("team.html", assigns)
  end

  @impl true
  def handle_event("validate", %{"team" => params}, socket) do
    team = socket.assigns.team
    changeset = Team.changeset(team, params)
    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end

  def handle_event("add_team", %{"team" => params}, socket) do
    team = socket.assigns.team
    changeset = Team.changeset(team, params)

    id = team.team_id
    name = changeset.changes.name

    case Attend.register_team(name, id) do
      {:ok, _game_id} ->
        {:noreply, socket}

      {:error, _reason} ->
        {:error, socket}
    end
  end

  def handle_event("add_player", %{"player" => params}, socket) do
    team_id = socket.assigns.team.team_id
    name = params["name"]
    email = params["email"]

    case Attend.add_player_to_team(team_id, name, email) do
      {:ok, _player_id} ->
        {:noreply, socket}

      {:error, _reason} ->
        {:error, socket}
    end
  end

  def handle_info({:events, events}, socket) do
    team =
      Enum.reduce(events, socket.assigns.team, fn e, t ->
        Attend.Aggregates.Team.apply(t, e)
      end)

    {:noreply, assign(socket, team: team)}
  end
end
