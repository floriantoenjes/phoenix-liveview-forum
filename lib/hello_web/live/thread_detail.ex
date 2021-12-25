defmodule HelloWeb.ThreadDetailLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Board
  alias Hello.Forum.Thread
  alias Hello.Forum.Post
  alias Hello.Forum.Notification

  def mount(%{"id" => board_id, "thread_id" => thread_id}, %{"current_author" => author}, socket) do
    thread = Forum.get_thread!(thread_id)
    posts = Forum.list_posts_paginated(board_id, thread_id, 0)

    changeset = Forum.change_post(%Post{})

    total_posts = List.first(Forum.get_post_count(thread_id))
    page_count = trunc(Float.ceil(total_posts / 10))
    pages = Enum.to_list(1..page_count)

    {:ok, socket |> assign(:author, author)
          |> assign(:board_id, board_id)
          |> assign(:thread, thread)
          |> assign(:changeset, changeset)
          |> assign(:posts, posts)
          |> assign(:pages, pages)
    }
  end

  def handle_params(%{"id" => board_id, "thread_id" => thread_id, "page" => page}, url, socket) do
    posts = Forum.list_posts_paginated(board_id, thread_id, String.to_integer(page))
    {:noreply, socket |> assign(:posts, posts)}
  end

  def handle_params(%{"id" => board_id, "thread_id" => thread_id}, url, socket) do
    posts = Forum.list_posts_paginated(board_id, thread_id, 0)
    {:noreply, socket |> assign(:posts, posts)}
  end

  def handle_event("changePage", %{"page" => page}, socket) do


    posts = Forum.list_posts_paginated(socket.assigns.board_id, socket.assigns.thread.id, String.to_integer(page))

    {:noreply, socket |> assign(:posts, posts)}
  end

  def handle_event("createPost", %{"post" => post_params}, socket) do
    new_post = Hello.Forum.create_post(socket.assigns.author, socket.assigns.thread, post_params)

    HelloWeb.Endpoint.broadcast("threads", "thread:new_post", "")

    {:noreply, assign(socket, :thread, Hello.Forum.get_thread!(socket.assigns.thread.id))}
  end

  def handle_event("subscribe", _params, socket) do
    Forum.subscribe_to_thread(socket.assigns.thread, socket.assigns.author)

    {:noreply, assign(socket, :thread, Hello.Forum.get_thread!(socket.assigns.thread.id))}
  end

  def handle_event("unsubscribe", _params, socket) do
    Forum.unsubscribe_from_thread(socket.assigns.thread, socket.assigns.author)

    {:noreply, assign(socket, :thread, Hello.Forum.get_thread!(socket.assigns.thread.id))}
  end

  def handle_info(%{event: "thread:new_post"}, socket) do
    thread = Hello.Forum.get_thread!(socket.assigns.thread.id)
    {:noreply, assign(socket, :thread, thread)}
  end

  def member_has_subscribed(thread, author) do
    Enum.any?(thread.subscribed_users, fn member -> member.id == author.id end)
  end

end