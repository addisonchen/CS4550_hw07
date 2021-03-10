defmodule Events.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :picture_hash, :string

    has_many :meetings, Events.Meetings.Meeting, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :picture_hash])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
