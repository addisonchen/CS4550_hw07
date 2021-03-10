defmodule Events.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :name, :text, null: false
      add :date, :utc_datetime, null: false
      add :description, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:meetings, [:user_id])
  end
end
