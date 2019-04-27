defmodule Attend.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :players, :jsonb, null: false, default: "[]"

      timestamps()
    end
  end
end
