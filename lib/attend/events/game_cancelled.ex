defmodule Attend.Events.GameCancelled do
  @derive Jason.Encoder
  defstruct [
    :game_id
  ]
end
