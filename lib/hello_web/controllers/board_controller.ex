defmodule HelloWeb.BoardController do
  use HelloWeb, :controller
  import Phoenix.LiveView.Controller

  alias Hello.Forum
  alias Hello.Forum.Board

  def index(conn, _params) do
    boards = Forum.list_boards()
    changeset = Forum.change_board(%Board{})
    live_render(conn, HelloWeb.BoardsLive, session: %{"boards" => boards, "changeset" => changeset})
  end

  def new(conn, _params) do
    changeset = Forum.change_board(%Board{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"board" => board_params}) do
    case Forum.create_board(board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    board = Forum.get_board!(id)
    render(conn, "show.html", board: board)
  end

  def edit(conn, %{"id" => id}) do
    board = Forum.get_board!(id)
    changeset = Forum.change_board(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Forum.get_board!(id)

    case Forum.update_board(board, board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Forum.get_board!(id)
    {:ok, _board} = Forum.delete_board(board)

    conn
    |> put_flash(:info, "Board deleted successfully.")
    |> redirect(to: Routes.board_path(conn, :index))
  end
end
