defmodule Attend.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :location, :string
      add :start_time, :naive_datetime
      # , references(:teams, on_delete: :nothing, type: :binary_id)
      add :team_id, :binary_id

      timestamps()
    end

    create index(:games, [:team_id])
  end
end
