defmodule Attend.Projections.Team do
  use Ecto.Schema
  import Ecto.Changeset

  defmodule Player do
    use Ecto.Schema

    @primary_key {:id, :binary_id, autogenerate: false}
    embedded_schema do
      field :name
      field :email
    end

    def changeset(player, attributes) do
      player
      |> cast(attributes, [:id, :name, :email])
      |> validate_required([:id, :name, :email])
    end
  end

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "teams" do
    field :name, :string

    embeds_many(:players, Player, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
    |> cast_embed(:players, required: false)
  end
end
