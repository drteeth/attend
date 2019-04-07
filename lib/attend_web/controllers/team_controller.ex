defmodule AttendWeb.TeamController do
  use AttendWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 3]
  alias AttendWeb.Team

  def index(conn, _params) do
    live_render(conn, Team.Index, session: %{})
  end

  def new(conn, _params) do
    live_render(conn, Team.Form, session: %{team_id: "FakeTeam"})
  end

  def show(conn, _params) do
    # TODO get the ID from the params
    # TODO preload the team?
    live_render(conn, Team.Form, session: %{team_id: "FakeTeam"})
  end
end
