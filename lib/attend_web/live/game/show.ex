defmodule AttendWeb.Game.Show do
  use Phoenix.LiveView

  alias Attend.Projections.Game

  def mount(%{path_params: %{"id" => game_id}}, socket) do
    game = Game.get(game_id)
    {:ok, assign(socket, :game, game)}
  end

  @impl true
  def render(assigns) do
    AttendWeb.GameView.render("show.html", assigns)
  end

  @impl true
  def handle_event("cancel_game", game_id, socket) do
    :ok = Attend.cancel_game(game_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("start_game", game_id, socket) do
    :ok = Attend.start_game(game_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("end_game", game_id, socket) do
    :ok = Attend.end_game(game_id)
    {:noreply, socket}
  end
end
