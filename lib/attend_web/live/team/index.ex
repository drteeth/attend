defmodule AttendWeb.Team.Index do
  use Phoenix.LiveView

  alias Attend.Projections.Team
  alias AttendWeb.Endpoint
  alias AttendWeb.TeamView

  @impl true
  def mount(_args, socket) do
    socket = assign(socket, teams: load_teams())

    if connected?(socket) do
      Endpoint.subscribe("teams")
    end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    TeamView.render("index.html", assigns)
  end

  @impl true
  def handle_info(%{event: "team_registered"}, socket) do
    {:noreply, assign(socket, teams: load_teams())}
  end

  defp load_teams(), do: Team.all()
end
