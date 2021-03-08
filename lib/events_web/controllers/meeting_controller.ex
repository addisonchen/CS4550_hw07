defmodule EventsWeb.MeetingController do
  use EventsWeb, :controller

  alias Events.Meetings
  alias Events.Meetings.Meeting
  alias EventsWeb.Plugs

  plug Plugs.RequireUser when action not in [:index, :show]
  plug :fetchMeeting when action not in [:index, :new, :create]
  plug :requireOwner when action in [:edit, :update, :delete]


  def fetchMeeting(conn, _params) do
    id = conn.params["id"]
    meeting = Meetings.get_meeting!(id)
    assign(conn, :meeting, meeting)
  end

  def requireOwner(conn, _params) do
    user = conn.assigns[:current_user]
    meeting = conn.assigns[:meeting]

    if user.id == meeting.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Cannot modify someone else's meeting")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    meetings = Meetings.list_meetings()
    render(conn, "index.html", meetings: meetings)
  end

  def new(conn, _params) do
    changeset = Meetings.change_meeting(%Meeting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"meeting" => meeting_params}) do
    IO.inspect meeting_params
    meeting_params = meeting_params
    |> Map.put("user_id", conn.assigns[:current_user].id)
    case Meetings.create_meeting(meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    meeting = conn.assigns[:meeting]
    render(conn, "show.html", meeting: meeting)
  end

  def edit(conn, _params) do
    meeting = conn.assigns[:meeting]
    changeset = Meetings.change_meeting(meeting)
    render(conn, "edit.html", meeting: meeting, changeset: changeset)
  end

  def update(conn, %{"meeting" => meeting_params}) do
    meeting = conn.assigns[:meeting]

    case Meetings.update_meeting(meeting, meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", meeting: meeting, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    meeting = conn.assigns[:meeting]
    {:ok, _meeting} = Meetings.delete_meeting(meeting)

    conn
    |> put_flash(:info, "Meeting deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :index))
  end
end
