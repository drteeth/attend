defmodule Attend.Team do
  @enforce_keys [:team_id, :name, :players]
  defstruct @enforce_keys

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

  def execute(%__MODULE__{}, %RegisterTeam{team_id: id, name: name}) do
    # TODO: don't register the same team twice
    %Attend.TeamRegistered{team_id: id, name: name}
  end

  def execute(%__MODULE__{}, %AddPlayerToTeam{team_id: id, player: player}) do
    %PlayerAddedToTeam{team_id: id, player: player}
  end

  def apply(team, %TeamRegistered{} = event) do
    %{team | team_id: event.team_id, name: event.name}
  end

  def apply(team, %PlayerAddedToTeam{player: player}) do
    players = [player | team.players]
    %{team | players: players}
  end
end
