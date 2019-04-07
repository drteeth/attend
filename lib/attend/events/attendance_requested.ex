defmodule Attend.Events.AttendanceRequested do

  alias Ecto.UUID

  @derive Jason.Encoder
  defstruct [
    player_check_id: nil,
    check_id: nil,
    game_id: nil,
    team: nil,
    player: nil,
    yes_token: UUID.generate(),
    no_token: UUID.generate(),
    maybe_token: UUID.generate()
  ]
end
