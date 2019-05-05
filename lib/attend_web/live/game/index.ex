defmodule AttendWeb.Game.Index do
  use Phoenix.LiveView

  alias Attend.Projections.Game
  alias AttendWeb.Endpoint
  alias AttendWeb.GameView

  @impl true
  def mount(_args, socket) do
    socket = assign(socket, games: load_games())

    if connected?(socket) do
      Endpoint.subscribe("games")
    end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    GameView.render("index.html", assigns)
  end

  @impl true
  def handle_info(%{event: "game_scheduled"}, socket) do
    {:noreply, assign(socket, teams: load_games())}
  end

  defp load_games() do
    Game.all()
  end
end
