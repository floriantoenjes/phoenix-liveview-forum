defmodule HelloWeb.BoardDetailLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Board
  alias Hello.Forum.Thread

  def mount(%{"id" => id}, %{"current_author" => author}, socket) do
    board = Forum.get_board!(id)
    changeset = Forum.change_thread(%Thread{})

    {:ok, socket |> assign(:author, author) |> assign(:board, board) |> assign(:changeset, changeset)}
  end

  def handle_event("createThread", %{"thread" => thread_params}, socket) do
    new_thread = Hello.Forum.create_thread(socket.assigns.author, socket.assigns.board, thread_params)

    HelloWeb.Endpoint.broadcast("boards", "board:new_thread", "")

    {:noreply, assign(socket, :board, Hello.Forum.get_board!(socket.assigns.board.id))}

  end

  def handle_info(%{event: "board:new_thread"}, socket) do
    board = Hello.Forum.get_board!(socket.assigns.board.id)
    {:noreply, assign(socket, :board, board)}
  end

end