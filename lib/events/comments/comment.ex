defmodule Events.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :time, :utc_datetime
    belongs_to :user, Events.Accounts.User
    belongs_to :meeting, Events.Meetings.Meeting

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :time])
    |> validate_required([:body, :time])
  end
end
