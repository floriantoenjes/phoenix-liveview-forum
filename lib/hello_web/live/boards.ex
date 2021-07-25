defmodule HelloWeb.BoardsLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Board

  def mount(_params, session, socket) do
    HelloWeb.Endpoint.subscribe("boards")

    boards = Forum.list_boards()
    changeset = Forum.change_board(%Board{})

    {:ok, socket |> assign(:changeset, changeset) |> assign(:boards, boards)}
  end

  def handle_event("save", %{"board" => board_params}, socket) do
    {:ok, _} = Hello.Forum.create_board(board_params)

    HelloWeb.Endpoint.broadcast("boards", "board:created", "")

    {:noreply, assign(socket, :boards, Hello.Forum.list_boards())}

  end

  def handle_info(%{event: "board:created"}, socket) do
    boards = Hello.Forum.list_boards()
    {:noreply, assign(socket, :boards, boards)}
  end

end