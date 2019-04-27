defmodule Attend.Aggregates.Team do
  defstruct team_id: nil, name: nil, players: [], checks: []

  alias __MODULE__, as: Team

  alias Attend.Commands.{
    RegisterTeam,
    JoinTeam,
    LeaveTeam,
    RequestTeamAttendance
  }

  alias Attend.Events.{
    TeamRegistered,
    JoinedTeam,
    LeftTeam,
    AttendanceCheckStarted,
    TeamAttendanceCheckStarted
  }

  def execute(%Team{}, %RegisterTeam{team_id: id, name: name}) do
    # TODO: don't register the same team twice
    %TeamRegistered{team_id: id, name: name}
  end

  def execute(%Team{}, %JoinTeam{team_id: id, player: player}) do
    player = Map.put(player, :id, Ecto.UUID.generate())
    %JoinedTeam{team_id: id, player: player}
  end

  def execute(%Team{} = team, %LeaveTeam{} = command) do
    player = find_player(team, command.player_id)

    if player do
      %LeftTeam{team_id: command.team_id, player_id: command.player_id}
    else
      {:error, :not_part_of_team}
    end
  end

  def execute(%Team{} = team, %RequestTeamAttendance{} = command) do
    %TeamAttendanceCheckStarted{
      check_id: command.check_id,
      game_id: command.game_id,
      team: Map.from_struct(team),
      players:
        Enum.map(team.players, fn player ->
          Map.put(player, :player_check_id, Ecto.UUID.generate())
        end)
    }
  end

  def apply(%Team{}, %TeamRegistered{} = event) do
    %Team{
      team_id: event.team_id,
      name: event.name
    }
  end

  def apply(%Team{} = team, %JoinedTeam{player: player}) do
    players = team.players ++ [player]
    %{team | players: players}
  end

  def apply(%Team{} = team, %LeftTeam{} = event) do
    player = find_player(team, event.player_id)
    players = List.delete(team.players, player)
    %{team | players: players}
  end

  def apply(%Team{} = team, %AttendanceCheckStarted{} = event) do
    checks = [event.check_id | team.checks]
    %{team | checks: checks}
  end

  def apply(%Team{} = team, %TeamAttendanceCheckStarted{}) do
    team
  end

  defp find_player(team, id) do
    Enum.find(team.players, fn p ->
      p.id == id
    end)
  end
end
