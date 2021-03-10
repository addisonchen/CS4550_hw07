defmodule EventsWeb.InviteController do
  use EventsWeb, :controller

  alias Events.Invites
  alias Events.Invites.Invite
  alias EventsWeb.Plugs
  alias Events.Meetings
  alias Events.Accounts


  plug Plugs.RequireUser when action not in [:index, :show]
  plug :requireMeetingOwnerCreate when action in [:create]
  plug :requireMeetingOwnerDelete when action in [:delete]
  plug :requireInvitedOrHost when action in [:update]

  # access control: onlymeeting owners can create invites
  def requireMeetingOwnerCreate(conn, _params) do    
    meeting_id = conn.params["invite"]["meeting_id"]
    
    meeting_owner_id = Meetings.get_meeting!(meeting_id).user.id

    cur_user_id = conn.assigns[:current_user].id

    if cur_user_id == meeting_owner_id do
      conn
    else
      conn
      |> put_flash(:error, "Only the meeting host can create invites")
      |> redirect(to: Routes.meeting_path(conn, :show, meeting_id))
      |> halt()
     end
  end

  # access control: only meeting owners can delete invites
  def requireMeetingOwnerDelete(conn, _params) do    
    invite_id = conn.params["id"]

    meeting_id = Invites.get_invite!(invite_id).meeting_id
    
    meeting_owner_id = Meetings.get_meeting!(meeting_id).user.id

    cur_user_id = conn.assigns[:current_user].id

    if cur_user_id == meeting_owner_id do
      conn
    else
      conn
      |> put_flash(:error, "Only the meeting host can create invites")
      |> redirect(to: Routes.meeting_path(conn, :show, meeting_id))
      |> halt()
     end
  end

  # access control: only the host or the person invited can modify
  def requireInvitedOrHost(conn, _params) do
    meeting_id = conn.params["invite"]["meeting_id"]
    
    meeting_owner_id = Meetings.get_meeting!(meeting_id).user.id

    invited_id = Accounts.get_user_by_email(conn.params["invite"]["email"]).id

    cur_user_id = conn.assigns[:current_user].id

    if (cur_user_id == meeting_owner_id) || (cur_user_id == invited_id) do
      conn
    else
      conn
      |> put_flash(:error, "Only the meeting host can create invites")
      |> redirect(to: Routes.meeting_path(conn, :show, meeting_id))
     end
  end
  


  def index(conn, _params) do
    invite = Invites.list_invite()
    render(conn, "index.html", invite: invite)
  end

  def new(conn, _params) do
    changeset = Invites.change_invite(%Invite{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invite" => invite_params}) do
    meeting = invite_params["meeting_id"]
    if Invites.check_invited(meeting, invite_params["email"]) do
      conn
        |> put_flash(:info, "That person is already invited. Share this link with the guest: http://events.swoogity.com/meetings/#{meeting}")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))
    else
      case Invites.create_invite(invite_params) do
        {:ok, _invite} ->
          conn
          |> put_flash(:info, "Invite created successfully. Share this link with the guest: http://events.swoogity.com/meetings/#{meeting}")
          |> redirect(to: Routes.meeting_path(conn, :show, meeting))

        {:error, %Ecto.Changeset{}} ->
          conn
          |> put_flash(:error, "Failed to create invite")
          |> redirect(to: Routes.meeting_path(conn, :show, meeting))
      end
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.html", invite: invite)
  end

  def edit(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    changeset = Invites.change_invite(invite)
    render(conn, "edit.html", invite: invite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    invite = Invites.get_invite!(id)
    meeting = invite_params["meeting_id"]
    case Invites.update_invite(invite, invite_params) do
      {:ok, _invite} ->
        conn
        |> put_flash(:info, "Response status updated successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Response status update failed.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    meeting = invite.meeting_id
    {:ok, _invite} = Invites.delete_invite(invite)

    conn
    |> put_flash(:info, "Invite deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :show, meeting))
  end
end
