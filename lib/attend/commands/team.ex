defmodule Attend.Models.Team do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    # TODO UUID..
    field :team_id, :string
    field :name, :string

    embeds_many :players, Attend.Player
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:team_id, :name])
    |> validate_required([:team_id, :name])
  end
end
