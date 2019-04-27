defmodule AttendWeb.Team.Index do
  use Phoenix.LiveView

  alias AttendWeb.Router.Helpers, as: Routes
  alias AttendWeb.Endpoint
  alias Attend.Repo
  alias Attend.Projections

  def mount(_args, socket) do
    if connected?(socket) do
      Endpoint.subscribe("teams")
    end
    {:ok, socket}
  end

  @table :team_index_cache

  def render(_params) do
    teams = Repo.all(Projections.Team)
    |> Enum.map(fn team ->
      link = Routes.team_path(Endpoint, :show, team.id)
      Map.put(team, :link, link)
    end)

    AttendWeb.TeamView.render("index.html", teams: teams)
  end

  def handle_info(%{topic: "teams", payload: team}, socket) do
    {:noreply, assign(socket, team: team)}
  end
end
