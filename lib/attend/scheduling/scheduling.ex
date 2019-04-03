defmodule Attend.Scheduling do
  alias Attend.CommandRouter
  alias Attend.Scheduling.Commands.SchedulePickupGame
  alias Ecto.UUID

  def schedule_pickup_game(team_id, location, start_time) do
    game_id = UUID.generate()

    cmd = %SchedulePickupGame{
      game_id: game_id,
      team_id: team_id,
      location: location,
      start_time: start_time
    }

    case CommandRouter.dispatch(cmd) do
      :ok ->
        {:ok, game_id}

      error ->
        error
    end
  end
end
