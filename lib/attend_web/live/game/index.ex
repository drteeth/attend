defmodule AttendWeb.Game.Index do
  use Phoenix.LiveView

  alias AttendWeb.Router.Helpers, as: Routes
  alias AttendWeb.Endpoint
  alias Attend.Projections.Game.Index, as: GameIndex

  def mount(_args, socket) do
    socket =
      assign(socket,
        games: load_games(),
        schedule_pickup_game_path: Routes.game_path(socket, :new)
      )

    if connected?(socket) do
      Endpoint.subscribe("games")
    end

    {:ok, socket}
  end

  def render(assigns) do
    AttendWeb.GameView.render("index.html", assigns)
  end

  defp load_games() do
    GameIndex.all()
    |> Enum.map(fn game ->
      link = Routes.game_path(Endpoint, :show, game["id"])
      Map.put(game, :link, link)
    end)
  end
end
