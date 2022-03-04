defmodule HelloWeb.ThreadDetailLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Board
  alias Hello.Forum.Thread
  alias Hello.Forum.Post
  alias Hello.Forum.Notification

  defp get_page_count(thread_id) do
    total_posts = List.first(Forum.get_post_count(thread_id))
    trunc(Float.ceil(total_posts / 10))
  end

  def mount(%{"id" => board_id, "thread_id" => thread_id}, %{"current_author" => author}, socket) do
    thread = Forum.get_thread!(thread_id)
    posts = Forum.list_posts_paginated(board_id, thread_id, 0)

    changeset = Forum.change_post(%Post{})

    pages = Enum.to_list(1..get_page_count(thread_id))

    {:ok, socket |> assign(:author, author)
          |> assign(:board_id, board_id)
          |> assign(:thread, thread)
          |> assign(:changeset, changeset)
          |> assign(:posts, posts)
          |> assign(:pages, pages)
          |> assign(:current_page, "1")
    }
  end

  def handle_params(%{"id" => board_id, "thread_id" => thread_id, "page" => page}, url, socket) do
    posts = Forum.list_posts_paginated(board_id, thread_id, (String.to_integer(page) - 1))
    {:noreply, socket |> assign(:posts, posts) |> assign(:current_page, page)}
  end

  def handle_params(%{"id" => board_id, "thread_id" => thread_id}, url, socket) do
    posts = Forum.list_posts_paginated(board_id, thread_id, 0)
    {:noreply, socket |> assign(:posts, posts)}
  end

  def handle_event("createPost", %{"post" => post_params}, socket) do
    new_post = Hello.Forum.create_post(socket.assigns.author, socket.assigns.thread, post_params)

    HelloWeb.Endpoint.broadcast("threads", "thread:new_post", "")

    posts = Forum.list_posts_paginated(socket.assigns.board_id, socket.assigns.thread.id, String.to_integer(socket.assigns.current_page) - 1)

    current_page = get_page_count(socket.assigns.thread.id)

    {:noreply, socket
               |> assign(:thread, Hello.Forum.get_thread!(socket.assigns.thread.id))
               |> assign(:posts, posts)
               |> assign(:page, current_page)
               |> redirect(to: Routes.live_path(socket, HelloWeb.ThreadDetailLive, socket.assigns.board_id, socket.assigns.thread.id)
                <> "?page=" <> Integer.to_string(current_page))
    }
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