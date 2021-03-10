defmodule EventsWeb.CommentController do
  use EventsWeb, :controller

  alias Events.Comments
  alias Events.Comments.Comment
  alias EventsWeb.Plugs
  alias EventsWeb.Helpers
  alias Events.Meetings

  plug Plugs.RequireUser when action not in [:index, :show]
  plug :requireInvitedOrHost when action in [:create]
  plug :requireHostOrCommenter when action in [:delete]
  plug :requireCommenter when action in [:update]


  def requireInvitedOrHost(conn, _opts) do
    meeting_id = conn.params["comment"]["meeting_id"]

    meeting = Meetings.get_meeting!(meeting_id)

    meeting_owner_id = meeting.user.id

    invites = meeting.invites

    cur_user_id = conn.assigns[:current_user].id

    if (cur_user_id == meeting_owner_id) ||  (Helpers.invited?(conn, invites)) do
      conn
    else
      conn
      |> put_flash(:danger, "Must be invited or the host to add a comment")
      |> redirect(to: Routes.meeting_path(conn, :show, meeting_id))
     end
  end

  def requireHostOrCommenter(conn, _opts) do
    comment_id = conn.params["id"]

    comment = Comments.get_comment!(comment_id)

    meeting_id = comment.meeting.id

    host_id = Meetings.get_meeting!(comment.meeting_id).user.id

    commenter_id = comment.user.id

    cur_user_id = conn.assigns[:current_user].id

    if (cur_user_id == host_id) || (cur_user_id == commenter_id) do
      conn
    else
      conn
      |> put_flash(:danger, "Must be a host or the comment poster to delete a comment")
      |> redirect(to: Routes.meeting_path(conn, :show, meeting_id))
    end
  end

  def requireCommenter(conn, _opts) do
    comment = conn.params["id"]
      |> Comments.get_comment!
    
    commenter_id = comment.user.id

    meeting_id = comment.meeting.id

    cur_user_id = conn.assigns[:current_user].id

    if (cur_user_id == commenter_id) do
      conn
    else
      conn
      |> put_flash(:danger, "Only the comment poster can modify a comment")
      |> redirect(to: Routes.meeting_path(conn, :show, meeting_id))
    end

  end

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    meeting = comment_params["meeting_id"]
    IO.puts "here"
    case Comments.create_comment(comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset
        conn
        |> put_flash(:danger, "Failed to create invite")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)
    meeting = comment_params["meeting_id"]
    case Comments.update_comment(comment, comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:info, "Failed to update comment.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    meeting = comment.meeting_id
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :show, meeting))
  end
end
