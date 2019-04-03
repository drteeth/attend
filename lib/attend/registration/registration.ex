defmodule Attend.Registration do
  alias Attend.CommandRouter
  alias Attend.Team.AddPlayerToTeam
  alias Attend.RegisterTeam
  alias Ecto.UUID

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
end
