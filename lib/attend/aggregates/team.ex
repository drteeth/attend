defmodule Attend.Aggregates.Team do
  defstruct team_id: nil, name: nil, players: [], checks: []

  alias __MODULE__, as: Team

  alias Attend.Commands.{
    RegisterTeam,
    JoinTeam,
    RequestTeamAttendance
  }

  alias Attend.Events.{
    TeamRegistered,
    JoinedTeam,
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

  def apply(%Team{} = team, %AttendanceCheckStarted{} = event) do
    checks = [event.check_id | team.checks]
    %{team | checks: checks}
  end

  def apply(%Team{} = team, %TeamAttendanceCheckStarted{}) do
    team
  end
end
