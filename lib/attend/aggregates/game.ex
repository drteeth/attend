defmodule Attend.Aggregates.Game do
  defstruct [:game_id, :location, :team_id, :start_time]

  alias __MODULE__, as: Game
  alias Attend.Commands.SchedulePickupGame
  alias Attend.Events.GameScheduled

  def execute(%Game{game_id: nil}, %SchedulePickupGame{} = command) do
    %GameScheduled{
      game_id: command.game_id,
      team_id: command.team_id,
      location: command.location,
      start_time: command.start_time
    }
  end

  def apply(%Game{}, %GameScheduled{} = event) do
    %Game{
      game_id: event.game_id,
      team_id: event.team_id,
      location: event.location,
      start_time: event.start_time
    }
  end
end
