defmodule Hello.Forum do
  @moduledoc """
  The Forum context.
  """

  import Ecto.Query, warn: false
  alias Hello.Repo

  alias Hello.Forum.{Board, CreateThread, Thread, Post, Member, Notification, Members_Notification}

  alias Ecto.Multi

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id) do
    Board
    |> Repo.get!(id)
    |> Repo.preload(threads:  [author: [user: :credential]])
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads()
      [%Thread{}, ...]

  """
  def list_threads(board_id) do
    Thread
    |> where(board_id: ^board_id)
    |> Repo.all()
    |> Repo.preload(author: [user: :credential])
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id) do
    Thread
    |> Repo.get!(id)
    |> Repo.preload(posts: [author: [user: :credential]], author: [user: :credential])
    |> Repo.preload(:board)
    |> Repo.preload(:subscribed_users)
  end

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(%Member{} = author, board, attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Ecto.Changeset.put_assoc(:board, board)
    |> Repo.insert()
  end


  def create_thread_with_post(%Member{} = author, board, attrs \\ %{}) do
    thread = Thread.changeset(%Thread{}, attrs)
             |> Ecto.Changeset.put_change(:author_id, author.id)
             |> Ecto.Changeset.put_assoc(:board, board)

    post = Post.changeset(%Post{}, attrs)
           |> Ecto.Changeset.put_change(:author_id, author.id)
           |> Ecto.Changeset.put_assoc(:thread, thread)
           |> Repo.insert()
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{data: %Thread{}}

  """
  def change_thread(%Thread{} = thread, attrs \\ %{}) do
    Thread.changeset(thread, attrs)
  end


  def change_create_thread(%CreateThread{} = createThread, attrs \\ %{}) do
    CreateThread.changeset(createThread, attrs)
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(board_id, thread_id) do
    thread = case Thread |> where(board_id: ^board_id) |> Repo.get(thread_id) do
      nil -> nil
      th -> th
    end

    cond do
      thread == nil -> []
      thread != nil -> Post |> where(thread_id: ^thread.id) |> Repo.all() |> Repo.preload(author: [user: :credential])
    end

  end

  def list_posts_paginated(board_id, thread_id, page) do
    thread = case Thread |> where(board_id: ^board_id) |> Repo.get(thread_id) do
      nil -> nil
      th -> th
    end

    cond do
      thread == nil -> []
      thread != nil -> Repo.all(from(p in Post, where: p.thread_id == ^thread.id) |> paginate(page, 10) |> preload(author: [user: :credential]))
    end
  end

  def get_post_count(thread_id) do
    query = from(p in Post,
      where: p.thread_id == ^thread_id,
      select: count(p.id))

    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Post
    |> Repo.get!(id)
    |> Repo.preload(author: [user: :credential])
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(%Member{} = author, thread, attrs \\ %{}) do
    post = Post.changeset(%Post{}, attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Ecto.Changeset.put_assoc(:thread, thread)

    result = Multi.new()
    |> Multi.insert(:post, post)

    thread = Repo.preload(thread, :subscribed_users)

    result2 = if Enum.any?(thread.subscribed_users, fn member -> member.id == author.id end) do

      notification = Notification.changeset(%Notification{}, %{type: 1, target_id: thread.id, resource_name: thread.title})
      |> Ecto.Changeset.put_assoc(:receiver, [author])

      Multi.insert(result, :notification, notification)
    end

    if result2 != nil do
      Repo.transaction(result2)
    else
      Repo.transaction(result)
    end

  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Hello.Forum.Member

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members do
    Repo.all(Member)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id) do
    Member
    |> Repo.get!(id)
    |> Repo.preload(user: :credential)
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{data: %Member{}}

  """
  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end


  def ensure_author_exists(%Hello.Accounts.User{} = user) do
    %Member{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_member()
  end
  defp handle_existing_member({:ok, member}), do: member
  defp handle_existing_member({:error, changeset}) do
    Repo.get_by!(Member, user_id: changeset.data.user_id)
  end

  alias Hello.Forum.Notification

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  def list_notifications_by_member(member) do

    #IO.puts(Map.from_struct(%Notification{}))
    Hello.Forum.Members_Notification
    |> where(member_id: ^member.id)
    |> Repo.all()
    |> Repo.preload(:notification)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  def list_subscribed_threads(author) do
    Repo.preload(author, :subscribed_threads).subscribed_threads |> Repo.preload(:board)
  end

  def subscribe_to_thread(thread, author) do
    Repo.preload(thread, :subscribed_users)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:subscribed_users, [author])
    |> Repo.update!()
  end

  def unsubscribe_from_thread(thread, author) do
    Repo.delete_all(from ts in "members_subscribed_threads", where: ts.thread_id == ^thread.id and ts.member_id == ^author.id, select: [ts.id, ts.member_id, ts.thread_id])
  end

  @doc """
  Deletes a notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do

    result = Members_Notification
    |> where(notification_id: ^notification.id)
    |> Repo.delete_all()

    Repo.delete(notification)
  end

  def delete_all_notifications_by_user_id(user_id) do
    notifications_by_user_query = Members_Notification
    |> where(member_id: ^user_id)

    notifications_by_user = Repo.all(notifications_by_user_query)

    Repo.delete_all(notifications_by_user_query)

    for nbu <- notifications_by_user do
      Hello.Forum.get_notification!(nbu.notification_id)
      |> Repo.delete()
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{data: %Notification{}}

  """
  def change_notification(%Notification{} = notification, attrs \\ %{}) do
    Notification.changeset(notification, attrs)
  end

  alias Hello.Forum.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def assign_session_defaults_to_socket(socket, %{"current_author" => author}) do
    socket |> Phoenix.LiveView.assign(:author, author)
  end

  def paginate(query, page, per_page) do
    offset_by = page * per_page

    query
    |> limit(^per_page)
    |> offset(^offset_by)
  end
end
