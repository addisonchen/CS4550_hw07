defmodule EventsWeb.UserController do
  use EventsWeb, :controller

  alias Events.Accounts
  alias Events.Accounts.User
  alias EventsWeb.Plugs
  alias Events.ProfilePictures
  alias EventsWeb.SessionController

  plug Plugs.RequireUser when action in [:edit, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    f = user_params["picture"]
    
    user_params = if f do
      email = user_params["email"]
      {:ok, hash} = ProfilePictures.save_photo(email, f.path)
      
      user_params = Map.put(user_params, "picture_hash", hash)
      Map.delete(user_params, "picture")
    else
      user_params = Map.put(user_params, "picture_hash", nil)
      Map.delete(user_params, "picture")
    end 

    user_params_filter_redirect = Map.delete(user_params, "redirect_to")

    case Accounts.create_user(user_params_filter_redirect) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> SessionController.create(user_params)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def picture(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _name, data} = ProfilePictures.load_photo(user.picture_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    f = user_params["picture"]

    user_params = if f do
      {:ok, hash} = ProfilePictures.save_photo(user.email, f.path)
      Map.put(user_params, "picture_hash", hash)
    else 
      Map.put(user_params, "picture_hash", nil)
    end

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
