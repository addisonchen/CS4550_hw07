defmodule Events.Meetings do
  @moduledoc """
  The Meetings context.
  """

  import Ecto.Query, warn: false
  alias Events.Repo

  alias Events.Meetings.Meeting

  @doc """
  Returns the list of meetings.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_meetings do
    Repo.all(Meeting)
    |> Repo.preload(:user)
  end

  def load_responses(%Meeting{} = meeting) do
    meeting = Repo.preload(meeting, :invites)

    invites = meeting.invites

    yes = Enum.reduce(invites, 0, fn(x, acc) ->
      if x.status == "yes" do
        acc + 1
      else
        acc
      end
    end)

    no = Enum.reduce(invites, 0, fn(x, acc) ->
      if x.status == "no" do
        acc + 1
      else
        acc
      end
    end)

    maybe = Enum.reduce(invites, 0, fn(x, acc) ->
      if x.status == "maybe" do
        acc + 1
      else
        acc
      end
    end)

    noResponse = Enum.reduce(invites, 0, fn(x, acc) ->
      if x.status == "none" do
        acc + 1
      else
        acc
      end
    end)

    %{yes: yes, no: no, maybe: maybe, noResponse: noResponse}
  end

  @doc """
  Gets a single meeting.

  Raises `Ecto.NoResultsError` if the Meeting does not exist.

  ## Examples

      iex> get_meeting!(123)
      %Meeting{}

      iex> get_meeting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting!(id) do
    Repo.get!(Meeting, id) 
      |> Repo.preload(:user)
      |> Repo.preload(:invites)
      |> Repo.preload(:comments)
  end
  @doc """
  Creates a meeting.

  ## Examples

      iex> create_meeting(%{field: value})
      {:ok, %Meeting{}}

      iex> create_meeting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting(attrs \\ %{}) do
    IO.inspect attrs
    %Meeting{}
    |> Meeting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meeting.

  ## Examples

      iex> update_meeting(meeting, %{field: new_value})
      {:ok, %Meeting{}}

      iex> update_meeting(meeting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting.

  ## Examples

      iex> delete_meeting(meeting)
      {:ok, %Meeting{}}

      iex> delete_meeting(meeting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.

  ## Examples

      iex> change_meeting(meeting)
      %Ecto.Changeset{data: %Meeting{}}

  """
  def change_meeting(%Meeting{} = meeting, attrs \\ %{}) do
    Meeting.changeset(meeting, attrs)
  end
end
