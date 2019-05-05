defmodule AttendWeb.Game.New do
  use Phoenix.LiveView

  alias Attend.Projections.Team
  alias AttendWeb.Router.Helpers, as: Routes
  alias AttendWeb.Endpoint

  def mount(_args, socket) do
    game_id = Ecto.UUID.generate()

    teams =
      Team.all()
      |> Enum.map(fn t -> {t.name, t.id} end)

    game = %{
      "id" => game_id,
      "location" => "Monarch Park - Field 3",
      "date" => "2019-06-22",
      "time" => "09:30",
      "team_id" => nil
    }

    socket =
      assign(socket,
        game: game,
        is_valid: is_valid(game),
        teams: teams
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    AttendWeb.GameView.render("new.html", assigns)
  end

  @impl true
  def handle_event("validate_game", %{"game" => params}, socket) do
    game =
      socket.assigns.game
      |> Map.merge(params, fn _key, old, new ->
        cond do
          new == nil || new == "" || new == old ->
            old

          true ->
            new
        end
      end)

    {:noreply, assign(socket, game: game, is_valid: is_valid(game))}
  end

  @impl true
  def handle_event("schedule_game", %{"game" => params}, socket) do
    team_id = params["team_id"]
    location = params["location"]

    # TODO: uhg timezones...
    # TODO do this parseing in the validation step
    date_str = "#{params["date"]}T#{params["time"]}:00.000+02:30"

    {:ok, start_time, _offset} = DateTime.from_iso8601(date_str)

    case Attend.schedule_pickup_game(team_id, location, start_time) do
      {:ok, game_id} ->
        path =
          Routes.live_path(Endpoint, AttendWeb.Game.Show, game_id)

        {:stop,
         socket
         |> put_flash(:info, "Game scheduled")
         |> redirect(to: path)}

      {:error, reason} ->
        {:noreply, assign(socket, error: reason)}
    end
  end

  # TODO move this to the Command with Vex
  def is_valid(game) do
    game["location"] != nil &&
      game["location"] |> String.length() > 2 &&
      game["date"] != nil &&
      game["time"] != nil &&
      game["team_id"] != nil
  end
end
