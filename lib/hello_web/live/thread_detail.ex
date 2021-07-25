defmodule HelloWeb.ThreadDetailLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Board
  alias Hello.Forum.Thread
  alias Hello.Forum.Post

  def mount(%{"id" => board_id, "thread_id" => thread_id}, %{"current_author" => author}, socket) do
    thread = Forum.get_thread!(thread_id)
    changeset = Forum.change_post(%Post{})

    {:ok, socket |> assign(:author, author) |> assign(:board_id, board_id) |> assign(:thread, thread) |> assign(:changeset, changeset)}
  end

  def handle_event("createPost", %{"post" => post_params}, socket) do
    new_post = Hello.Forum.create_post(socket.assigns.author, socket.assigns.thread, post_params)

    HelloWeb.Endpoint.broadcast("threads", "thread:new_post", "")

    {:noreply, assign(socket, :thread, Hello.Forum.get_thread!(socket.assigns.thread.id))}

  end

  def handle_info(%{event: "thread:new_post"}, socket) do
    thread = Hello.Forum.get_thread!(socket.assigns.thread.id)
    {:noreply, assign(socket, :thread, thread)}
  end

end