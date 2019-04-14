defmodule Attend.Models.Player do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :binary_id
    field :email, :string
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:id, :name, :email])
    |> validate_required([:name, :email])
  end
end
