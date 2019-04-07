defmodule Attend.Projections.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    field :location, :string
    field :start_time, :naive_datetime
    field :team_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:location, :start_time])
    |> validate_required([:location, :start_time])
  end
end
