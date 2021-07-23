defmodule HelloWeb.ThreadController do
  use HelloWeb, :controller

  alias Hello.Forum
  alias Hello.Forum.Thread

  def index(conn, %{"board_id" => board_id}) do
    threads = Forum.list_threads()
    render(conn, "index.html", board_id: board_id, threads: threads)
  end

  def new(conn, %{"board_id" => board_id}) do
    changeset = Forum.change_thread(%Thread{})
    render(conn, "new.html", board_id: board_id, changeset: changeset)
  end

  def create(conn, %{"board_id" => board_id, "thread" => thread_params}) do
    board = Forum.get_board!(board_id)
    case Forum.create_thread(board, thread_params) do
      {:ok, thread} ->
        conn
        |> put_flash(:info, "Thread created successfully.")
        |> redirect(to: Routes.board_thread_path(conn, :show, board_id, thread))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", board_id: board_id, changeset: changeset)
    end
  end

  def show(conn, %{"board_id" => board_id, "id" => id}) do
    thread = Forum.get_thread!(id)
    render(conn, "show.html", thread: thread, board_id: board_id)
  end

  def edit(conn, %{"board_id" => board_id, "id" => id}) do
    thread = Forum.get_thread!(id)
    changeset = Forum.change_thread(thread)
    render(conn, "edit.html", board_id: board_id, thread: thread, changeset: changeset)
  end

  def update(conn, %{"board_id" => board_id, "id" => id, "thread" => thread_params}) do
    thread = Forum.get_thread!(id)

    case Forum.update_thread(thread, thread_params) do
      {:ok, thread} ->
        conn
        |> put_flash(:info, "Thread updated successfully.")
        |> redirect(to: Routes.board_thread_path(conn, :show, board_id, thread))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board_id: board_id, thread: thread, changeset: changeset)
    end
  end

  def delete(conn, %{"board_id" => board_id, "id" => id}) do
    thread = Forum.get_thread!(id)
    {:ok, _thread} = Forum.delete_thread(thread)

    conn
    |> put_flash(:info, "Thread deleted successfully.")
    |> redirect(to: Routes.board_thread_path(conn, :index, board_id))
  end
end
