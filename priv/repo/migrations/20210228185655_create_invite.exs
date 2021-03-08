defmodule Events.Repo.Migrations.CreateInvite do
  use Ecto.Migration

  def change do
    create table(:invite) do
      add :status, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :meeting_id, references(:meetings, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:invite, [:user_id])
    create index(:invite, [:meeting_id])
  end
end
