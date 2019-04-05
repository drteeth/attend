defmodule Attend.Commands.AskPlayerForAttendance do
  defstruct player_check_id: Ecto.UUID.generate(),
            check_id: nil,
            game_id: nil,
            team_id: nil,
            player: nil,
            yes_token: Ecto.UUID.generate(),
            no_token: Ecto.UUID.generate(),
            maybe_token: Ecto.UUID.generate()
end
