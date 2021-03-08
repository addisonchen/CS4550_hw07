defmodule EventsWeb.Helpers do
  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def current_user_id?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end

  def invited?(conn, email) do
    user = conn.assigns[:current_user]
    user && user.email == email
  end
end