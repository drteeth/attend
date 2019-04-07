defmodule Attend.Aggregates.Team do
  defstruct team_id: nil, name: nil, players: [], checks: []

  alias __MODULE__, as: Team
  alias Attend.Commands.{RegisterTeam, JoinTeam, CheckAttendance}
  alias Attend.Events.{TeamRegistered, PlayerAddedToTeam, AttendanceCheckStarted}

  def execute(%Team{}, %RegisterTeam{team_id: id, name: name}) do
    # TODO: don't register the same team twice
    %TeamRegistered{team_id: id, name: name}
  end

  def execute(%Team{}, %JoinTeam{team_id: id, player: player}) do
    # TODO don't assign ID here.
    player = Map.put(player, :id, Ecto.UUID.generate())
    %PlayerAddedToTeam{team_id: id, player: player}
  end

  def execute(%Team{} = team, %CheckAttendance{} = command) do
    %AttendanceCheckStarted{
      check_id: command.check_id,
      game_id: command.game_id,
      team: Map.from_struct(team),
      players:
        Enum.map(team.players, fn p ->
          p |> Map.put(:player_check_id, Ecto.UUID.generate())
        end)
    }
  end

  # TODO: CompleteAttendanceCheck, FailAttendanceCheck

  def apply(%Team{}, %TeamRegistered{} = event) do
    %Team{
      team_id: event.team_id,
      name: event.name
    }
  end

  def apply(%Team{} = team, %PlayerAddedToTeam{player: player}) do
    players = [player | team.players]
    %{team | players: players}
  end

  def apply(%Team{} = team, %AttendanceCheckStarted{} = event) do
    checks = [event.check_id | team.checks]
    %{team | checks: checks}
  end
end
