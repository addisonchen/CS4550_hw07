defmodule EventsWeb.SessionController do
  use EventsWeb, :controller

  def create(conn, params) do
    user = Events.Accounts.get_user_by_email(params["email"])
    IO.inspect params
    if Map.has_key?(params, "redirect_to") do
      if user do
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back #{user.name}")
        |> redirect(to: params["redirect_to"])
      else
        conn
        |> put_flash(:error, "Login failed.")
        |> redirect(to: params["redirect_to"])
      end
    else 
      if user do
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back #{user.name}")
        |> redirect(to: Routes.page_path(conn, :index))
      else
        conn
        |> put_flash(:error, "Login failed.")
        |> redirect(to: Routes.page_path(conn, :index))
      end
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end