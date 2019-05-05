defmodule AttendWeb.Team.New do
  use Phoenix.LiveView

  alias Attend.Models.Team
  alias AttendWeb.Router.Helpers, as: Routes
  alias AttendWeb.Endpoint

  @impl true
  def mount(_args, socket) do
    team_id = Ecto.UUID.generate()
    team = Team.changeset(%Team{team_id: team_id}, %{})
    socket = assign(socket, changeset: team)

    if(connected?(socket)) do
      Endpoint.subscribe("teams:#{team_id}")
    end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    AttendWeb.TeamView.render("new.html", assigns)
  end

  @impl true
  def handle_event("validate_team", %{"team" => params}, socket) do
    team = socket.assigns.changeset.data
    changeset = Team.changeset(team, params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("register_team", %{"team" => params}, socket) do
    team = socket.assigns.changeset.data

    case Attend.register_team(params["name"], team.team_id) do
      {:ok, team_id} ->
        {:stop,
         socket
         |> put_flash(:info, "Team registered successfully.")
         |> redirect(to: Routes.live_path(Endpoint, AttendWeb.Team.Show, team_id))}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info(%{event: "team_registered", payload: team}, socket) do
    {:noreply, assign(socket, team: team)}
  end
end
