defmodule EventsWeb.PageController do
  use EventsWeb, :controller

  def index(conn, _params) do
    users = Events.Accounts.list_users()
    meetings = Events.Meetings.list_meetings()
    render(conn, "index.html", users: users, meetings: meetings)

  end
end
