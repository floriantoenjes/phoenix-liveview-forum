defmodule HelloWeb.BoardDetailLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Board
  alias Hello.Forum.Thread
  alias Hello.Forum.Post
  alias Hello.Forum.CreateThread

  def mount(%{"id" => id}, %{"current_author" => author}, socket) do
    board = Forum.get_board!(id)
    changeset = Forum.change_create_thread(%CreateThread{})

    {:ok, socket |> assign(:author, author) |> assign(:board, board) |> assign(:changeset, changeset)}
  end

  def handle_event("createThread", %{"create_thread" => thread_with_post_params}, socket) do
    Hello.Forum.create_thread_with_post(socket.assigns.author, socket.assigns.board, thread_with_post_params)

    HelloWeb.Endpoint.broadcast("boards", "board:new_thread", "")

    {:noreply, assign(socket, :board, Hello.Forum.get_board!(socket.assigns.board.id))}

  end

  def handle_info(%{event: "board:new_thread"}, socket) do
    board = Hello.Forum.get_board!(socket.assigns.board.id)
    {:noreply, assign(socket, :board, board)}
  end

end