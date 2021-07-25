defmodule HelloWeb.BoardDetailLive do
  use HelloWeb, :live_view

  def mount(_params, %{"author" => author, "board" => board, "changeset" => changeset}, socket) do
#    HelloWeb.Endpoint.subscribe("boards")

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