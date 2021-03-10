defmodule EventsWeb.Helpers do
  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def current_user_id?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end

  def invited?(conn, [h | t]) do
    user = conn.assigns[:current_user]
    if user do
      if user.email == h.email do
        h
      else
        invited?(conn, t)
      end
    else
      false
    end
  end

  def invited?(_conn, []) do
    false
  end
end