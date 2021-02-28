defmodule Events.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invite" do
    field :status, :string
    belongs_to :user, Events.Accounts.User
    belongs_to :meeting, Events.Meetings.Meeting

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [])
    |> validate_required([])
  end
end
