defmodule Attend.Aggregates.Game do
  defstruct [:game_id, :location, :team_id, :start_time, :status]

  alias __MODULE__, as: Game
  alias Attend.Commands.{SchedulePickupGame, StartGame, EndGame}
  alias Attend.Events.{GameScheduled, GameStarted, GameEnded}

  def execute(%Game{game_id: nil}, %SchedulePickupGame{} = command) do
    %GameScheduled{
      game_id: command.game_id,
      team_id: command.team_id,
      location: command.location,
      start_time: command.start_time
    }
  end

  def execute(%Game{} = game, %StartGame{}) do
    now = DateTime.utc_now()

    if DateTime.compare(game.start_time, now) == :lt do
      %GameStarted{
        game_id: game.game_id,
        location: game.location,
        team_id: game.team_id,
        start_time: game.start_time,
        started_at: now
      }
    else
      {:error, :cant_start_game_before_start_time}
    end
  end

  def execute(%Game{} = game, %EndGame{}) do
    if game.status != :ended do
      %GameEnded{game_id: game.game_id}
    end
  end

  def apply(%Game{}, %GameScheduled{} = event) do
    %Game{
      game_id: event.game_id,
      team_id: event.team_id,
      location: event.location,
      start_time: event.start_time,
      status: :scheduled
    }
  end

  def apply(%Game{} = game, %GameStarted{}) do
    %{game | status: :started}
  end

  def apply(%Game{} = game, %GameEnded{}) do
    %{game | status: :ended}
  end
end
