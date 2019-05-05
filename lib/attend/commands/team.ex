defmodule Attend.Models.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :team_id}
  embedded_schema do
    field :team_id, :binary_id
    field :name, :string

    embeds_many :players, Attend.Player
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:team_id, :name])
    |> validate_required([:team_id, :name])
    |> validate_length(:name, min: 3)
  end
end
