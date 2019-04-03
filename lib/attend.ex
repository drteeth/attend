defmodule Attend do
  alias Ecto.UUID

  alias Attend.CommandRouter

  alias Attend.Commands.{
    SchedulePickupGame,
    AddPlayerToTeam,
    RegisterTeam,
    CheckAttendance
  }

  def register_team(name, id \\ nil) do
    team_id = id || UUID.generate()

    cmd = %RegisterTeam{
      team_id: team_id,
      name: name
    }

    case CommandRouter.dispatch(cmd) do
      :ok ->
        {:ok, team_id}

      error ->
        error
    end
  end

  def add_player_to_team(team_id, name, email) do
    cmd = %AddPlayerToTeam{
      team_id: team_id,
      player: %{
        name: name,
        email: email
      }
    }

    case CommandRouter.dispatch(cmd, include_execution_result: true) do
      {:ok, %{events: [player: %{id: player_id}]}} ->
        {:ok, player_id}

      error ->
        error
    end
  end

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

  def check_attendance(game_id, team_id) do
    check_id = UUID.generate()

    cmd = %CheckAttendance{
      check_id: check_id,
      game_id: game_id,
      team_id: team_id
    }

    case CommandRouter.dispatch(cmd) do
      :ok ->
        {:ok, check_id}

      error ->
        error
    end
  end
end
