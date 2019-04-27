defmodule AttendWeb.Team.Index do
  use Phoenix.LiveView

  alias AttendWeb.Router.Helpers, as: Routes
  alias AttendWeb.Endpoint
  alias Attend.Repo
  alias Attend.Projections

  def mount(_args, socket) do
    socket =
      assign(socket,
        teams: load_teams(),
        register_team_path: Routes.team_path(socket, :new)
      )

    if connected?(socket) do
      Endpoint.subscribe("teams")
    end

    {:ok, socket}
  end

  def render(assigns) do
    AttendWeb.TeamView.render("index.html", assigns)
  end

  def handle_info(%{event: "team_registered"}, socket) do
    {:noreply, assign(socket, teams: load_teams())}
  end

  defp load_teams() do
    Repo.all(Projections.Team)
    |> Enum.map(fn team ->
      link = Routes.team_path(Endpoint, :show, team.id)
      Map.put(team, :link, link)
    end)
  end
end
