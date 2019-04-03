defmodule AttendWeb.Team.Index do
  use Phoenix.LiveView

  def mount(_args, socket) do
    {:ok, socket}
  end

  def render(_params) do
    teams = []
    AttendWeb.TeamView.render("index.html", teams: teams)
  end
end
