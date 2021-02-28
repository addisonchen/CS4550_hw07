defmodule Events.Plugs.RequireUser do
  use EventsWeb, :controller

  def init(args), do: args

  def call(conn, _args) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "Log in or create an account")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end