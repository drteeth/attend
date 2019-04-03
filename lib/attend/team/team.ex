defmodule Attend.Team do
  @enforce_keys [:team_id, :name, :players]
  defstruct @enforce_keys

  alias __MODULE__, as: Team
  alias Attend.{RegisterTeam, TeamRegistered}

  defmodule AddPlayerToTeam do
    @enforce_keys [:team_id, :player]
    defstruct @enforce_keys
  end

  defmodule PlayerAddedToTeam do
    @enforce_keys [:team_id, :player]
    @derive Jason.Encoder
    defstruct @enforce_keys
  end

  def execute(%Team{}, %RegisterTeam{team_id: id, name: name}) do
    # TODO: don't register the same team twice
    %Attend.TeamRegistered{team_id: id, name: name}
  end

  def execute(%Team{}, %AddPlayerToTeam{team_id: id, player: player}) do
    player = Map.put(player, :id, Ecto.UUID.generate())
    %PlayerAddedToTeam{team_id: id, player: player}
  end

  def execute(%Team{} = team, %CheckAttendance{} = command) do
    %AttendanceCheckStarted{
      check_id: command.check_id,
      game_id: command.game_id,
      team_id: command.team_id,
      players: team.players
    }
  end

  def apply(team, %TeamRegistered{} = event) do
    %{team | team_id: event.team_id, name: event.name}
  end

  def apply(team, %PlayerAddedToTeam{player: player}) do
    players = [player | team.players]
    %{team | players: players}
  end

  def apply(%Check{}, %AttendanceCheckStarted{} = event) do
    %Check{
      check_id: event.check_id,
    }
  end

end
