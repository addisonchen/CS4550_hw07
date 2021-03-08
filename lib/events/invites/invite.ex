defmodule Events.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invite" do
    field :status, :string
    field :email, :string
    belongs_to :meeting, Events.Meetings.Meeting

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:status, :email, :meeting_id])
    |> validate_required([:status, :email, :meeting_id])
  end
end
