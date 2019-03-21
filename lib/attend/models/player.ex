defmodule Attend.Models.Player do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    # TODO UUID..
    field :name, :string
    field :email, :string
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:id, :name, :email])
    |> validate_required([:id, :name, :email])
  end
end
