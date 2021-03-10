defmodule Events.Meetings.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :date, :utc_datetime
    field :name, :string
    field :description, :string
    belongs_to :user, Events.Accounts.User

    has_many :invites, Events.Invites.Invite, on_delete: :delete_all
    has_many :comments, Events.Comments.Comment, on_delete: :delete_all


    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:name, :date, :user_id, :description])
    |> validate_required([:name, :date, :user_id, :description])
  end
end
