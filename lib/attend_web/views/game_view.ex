defmodule AttendWeb.GameView do
  use AttendWeb, :view

  alias AttendWeb.Endpoint
  alias AttendWeb.Router.Helpers, as: Routes

  def game_path(game) do
    Routes.live_path(Endpoint, AttendWeb.Game.Show, game.id)
  end
end
