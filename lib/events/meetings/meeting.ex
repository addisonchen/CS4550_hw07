defmodule Events.Meetings.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :date, :utc_datetime
    field :name, :string
    field :description, :string
    belongs_to :user, Events.Accounts.User

    has_many :invites, Events.Invites.Invite
    has_many :comments, Events.Comments.Comment


    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    IO.inspect attrs
    meeting
    |> cast(attrs, [:name, :date, :user_id, :description])
    |> validate_required([:name, :date, :user_id, :description])
  end
end
