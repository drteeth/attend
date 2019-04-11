defmodule Attend do
  alias Ecto.UUID

  alias Attend.CommandRouter

  alias Attend.Commands.{
    SchedulePickupGame,
    JoinTeam,
    RegisterTeam,
    CheckAttendance,
    ConfirmAttendance,
    StartGame,
    EndGame
  }

  def register_team(name, id \\ nil) do
    team_id = id || UUID.generate()

    command = %RegisterTeam{
      team_id: team_id,
      name: name
    }

    case CommandRouter.dispatch(command) do
      :ok ->
        {:ok, team_id}

      error ->
        error
    end
  end

  def add_player_to_team(team_id, name, email) do
    command = %JoinTeam{
      team_id: team_id,
      player: %{
        name: name,
        email: email
      }
    }

    case CommandRouter.dispatch(command, include_execution_result: true) do
      {:ok, %{events: [player: %{id: player_id}]}} ->
        {:ok, player_id}

      error ->
        error
    end
  end

  def schedule_pickup_game(team_id, location, start_time) do
    game_id = UUID.generate()

    command = %SchedulePickupGame{
      game_id: game_id,
      team_id: team_id,
      location: location,
      start_time: start_time
    }

    case CommandRouter.dispatch(command) do
      :ok ->
        {:ok, game_id}

      error ->
        error
    end
  end

  def check_attendance(game_id, team_id) do
    check_id = UUID.generate()

    command = %CheckAttendance{
      check_id: check_id,
      game_id: game_id,
      team_id: team_id
    }

    case CommandRouter.dispatch(command) do
      :ok ->
        {:ok, check_id}

      error ->
        error
    end
  end

  def confirm_attendance(player_check_id, token, message) do
    command = %ConfirmAttendance{
      player_check_id: player_check_id,
      response_token_id: token,
      message: message
    }

    case CommandRouter.dispatch(command) do
      :ok ->
        {:ok, player_check_id}

      error ->
        error
    end
  end

  def start_game(game_id) do
    command = %StartGame{game_id: game_id}
    CommandRouter.dispatch(command)
  end

  def end_game(game_id) do
    command = %EndGame{game_id: game_id}
    CommandRouter.dispatch(command)
  end
end
