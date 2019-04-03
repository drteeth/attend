defmodule Attend.Scheduling.Aggregates.Game do
  defstruct [:game_id, :location, :team_id, :start_time]

  alias Attend.Scheduling.Aggregates.Game
  alias Attend.Scheduling.Commands.SchedulePickupGame
  alias Attend.Scheduling.Events.GameScheduled

  def execute(%Game{game_id: nil}, %SchedulePickupGame{} = command) do
    %GameScheduled{
      game_id: command.game_id,
      team_id: command.team_id,
      location: command.location,
      start_time: command.start_time
    }
  end

  def apply(%Game{} = game, %GameScheduled{} = event) do
    %Game{
      game_id: event.game_id,
      team_id: event.team_id,
      location: event.location,
      start_time: event.start_time
    }
  end
end
