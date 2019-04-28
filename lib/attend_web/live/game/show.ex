defmodule AttendWeb.Game.Show do
  use Phoenix.LiveView

  def mount(%{game_id: _game_id}, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    AttendWeb.GameView.render("show.html", assigns)
  end
end
