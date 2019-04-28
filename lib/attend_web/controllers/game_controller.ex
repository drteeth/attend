defmodule AttendWeb.GameController do
  use AttendWeb, :controller

  alias AttendWeb.Game

  import Phoenix.LiveView.Controller, only: [live_render: 3]

  def index(conn, _params) do
    live_render(conn, Game.Index, session: %{games: []})
  end

  def new(conn, _params) do
    game_id = Ecto.UUID.generate()
    live_render(conn, Game.New, session: %{game_id: game_id})
  end

  def show(conn, %{"id" => game_id}) do
    live_render(conn, Game.Show, session: %{game_id: game_id})
  end
end
