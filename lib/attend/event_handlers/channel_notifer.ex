defmodule Attend.EventHandlers.ChannelNotifier do
  use Commanded.Event.Handler, name: __MODULE__, start_from: :current

  defmodule Team do
    defstruct [:team_id, :name, players: []]
  end

  defmodule Player do
    defstruct [:id, :name, :email]
  end

  alias Attend.Events
  alias AttendWeb.Endpoint

  def init() do
    :ets.new(:channel_foo, [:named_table])
    :ok
  end

  def handle(%Events.TeamRegistered{} = event, _metadata) do
    team = %Team{
      team_id: event.team_id,
      name: event.name
    }

    :ets.insert(:channel_foo, {event.team_id, team})

    Endpoint.broadcast("teams", "team_registered", Map.from_struct(team))
    :ok
  end

  def handle(%Events.JoinedTeam{} = event, _metadata) do
    [{_id, team}] = :ets.lookup(:channel_foo, event.team_id)

    players =
      team.players ++
        [
          %{
            name: event.player.name,
            email: event.player.email
          }
        ]

    team = %{team | players: players}

    :ets.insert(:channel_foo, {event.team_id, team})

    Endpoint.broadcast("teams", "joined", Map.from_struct(team))
    :ok
  end
end
