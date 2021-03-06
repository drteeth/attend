defmodule Attend.Aggregates.Game do
  defstruct [
    :game_id,
    :location,
    :team_id,
    :start_time,
    :status
  ]

  alias __MODULE__, as: Game

  alias Attend.Commands.{
    SchedulePickupGame,
    CheckAttendance,
    StartGame,
    CancelGame,
    EndGame
  }

  alias Attend.Events.{
    GameScheduled,
    GameStarted,
    GameCancelled,
    GameEnded,
    AttendanceCheckStarted
  }

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

    cond do
      game.status == :cancelled ->
        {:error, :game_cancelled}

      game.status == :ended ->
        {:error, :game_already_ended}

      game.status == :started ->
        {:error, :game_already_started}

      DateTime.compare(now, game.start_time) == :lt ->
        {:error, :cant_start_game_before_start_time}

      game.status == :scheduled ->
        %GameStarted{
          game_id: game.game_id,
          location: game.location,
          team_id: game.team_id,
          start_time: game.start_time,
          started_at: now
        }
    end
  end

  def execute(%Game{} = game, %CheckAttendance{} = command) do
    cond do
      game.status == :cancelled ->
        {:error, :game_cancelled}

      game.status == :ended ->
        {:error, :game_already_ended}

      game.team_id != command.team_id ->
        {:error, :team_not_scheduled_for_game}

      true ->
        %AttendanceCheckStarted{
          check_id: command.check_id,
          game_id: command.game_id,
          team_id: command.team_id
        }
    end
  end

  def execute(%Game{} = game, %CancelGame{}) do
    if game.status != :ended do
      %GameCancelled{
        game_id: game.game_id
      }
    else
      {:error, "Can't cancel a game in the #{game.status} state."}
    end
  end

  def execute(%Game{} = game, %EndGame{}) do
    if game.status == :started do
      %GameEnded{
        game_id: game.game_id
      }
    else
      {:error, "Can't end game in the #{game.status} state."}
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

  def apply(%Game{} = game, %AttendanceCheckStarted{}) do
    game
  end

  def apply(%Game{} = game, %GameStarted{}) do
    %{game | status: :started}
  end

  def apply(%Game{} = game, %GameEnded{}) do
    %{game | status: :ended}
  end

  def apply(%Game{} = game, %GameCancelled{}) do
    %{game | status: :cancelled}
  end
end
