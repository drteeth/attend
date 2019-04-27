defmodule AttendWeb.TeamController do
  use AttendWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 3]
  alias AttendWeb.Team

  def index(conn, _params) do
    teams = []
    live_render(conn, Team.Index, session: %{teams: teams})
  end

  def new(conn, _params) do
    live_render(conn, Team.New, session: %{team_id: Ecto.UUID.generate()})
  end

  def show(conn, %{"id" => team_id}) do
    live_render(conn, Team.Show, session: %{team_id: team_id})
  end
end
