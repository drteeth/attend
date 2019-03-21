defmodule Attend.CommandRouter do
  use Commanded.Commands.Router

  alias Attend.{Team, RegisterTeam}

  identify(Team, by: :team_id)
  dispatch([RegisterTeam], to: Team)
  dispatch([Team.AddPlayerToTeam], to: Team)
end
