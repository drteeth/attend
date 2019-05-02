defmodule AttendWeb.Team.Show do
  use Phoenix.LiveView

  alias Attend.Models.Player
  alias AttendWeb.Endpoint
  alias Attend.Projections

  @impl true
  def mount(%{team_id: team_id}, socket) do
    # TODO handle race condition:
    # The projection may not have finished creating the team
    # Handle it
    team = Projections.Team.Show.get(team_id)

    player = build_player()

    socket =
      assign(socket,
        team: team,
        changeset: player
      )

    if(connected?(socket)) do
      Endpoint.subscribe("teams:#{team_id}")
    end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    AttendWeb.TeamView.render("show.html", assigns)
  end

  @impl true
  def handle_event("validate_player", %{"player" => params}, socket) do
    player = socket.assigns.changeset.data
    changeset = Player.changeset(player, params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("add_player", %{"player" => params}, socket) do
    team_id = socket.assigns.team.id
    name = params["name"]
    email = params["email"]

    case Attend.add_player_to_team(team_id, name, email) do
      {:ok, _player_id} ->
        {:noreply, assign(socket, changeset: build_player())}

      {:error, _reason} ->
        {:error, socket}
    end
  end

  @impl true
  def handle_event("remove_player", player_id, socket) do
    team = socket.assigns.team

    case Attend.remove_player_from_team(team.id, player_id) do
      :ok ->
        {:noreply, socket}

      {:error, reason} ->
        IO.inspect(reason)
        {:noreply, assign(socket, error: reason)}
    end
  end

  @impl true
  def handle_info(%{event: "joined_team", payload: team}, socket) do
    {:noreply, assign(socket, team: team)}
  end

  defp build_player() do
    Player.changeset(%Player{}, %{})
  end
end
