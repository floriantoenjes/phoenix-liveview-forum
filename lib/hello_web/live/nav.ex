defmodule HelloWeb.NavLive do
  use Phoenix.LiveComponent
  use HelloWeb, :live_view

  def mount(socket) do
    HelloWeb.Endpoint.subscribe("threads")
    {:ok, socket }
  end

  def update(assigns, socket) do
    notifications = if assigns.author do
      member_notifications = Hello.Forum.list_notifications_by_member(assigns.author)

      Enum.map(member_notifications, fn mn -> mn.notification end)
    else
      []
    end
    {:ok, socket |> assign(:notifications, notifications) |> assign(:author, assigns.author)}
  end

  def handle_info(%{event: "thread:new_post"}, socket) do
    member_notifications = Hello.Forum.list_notifications_by_member(socket.assigns.author)

    notifications = Enum.map(member_notifications, fn mn -> mn.notification end)

    IO.puts("HIT")

    {:no_reply, socket |> assign(:notifications, notifications)}
  end

  def get_notification_link(socket, notification) do
    thread = Hello.Forum.get_thread!(notification.target_id)

    Routes.board_thread_path(socket, :show, thread.board.id, thread)
  end

  def handle_event("mark_notification_read", %{"notification-id" => notification_id}, socket) do
    notification = Hello.Forum.get_notification!(notification_id)

    Hello.Forum.delete_notification(notification)

    {:noreply, redirect(socket, to: get_notification_link(socket, notification))}
  end

  def handle_event("clear_notifications", _, socket) do
    Hello.Forum.delete_all_notifications_by_user_id(socket.assigns.author.id)

    {:noreply, socket |> assign(:notifications, [])}
  end

end
