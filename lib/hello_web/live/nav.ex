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

      #IO.puts(member_notifications)

      Enum.map(member_notifications, fn mn -> mn.notification end)
    else
      []
    end
    {:ok, socket |> assign(:notifications, notifications) |> assign(:author, assigns.author)}
  end

  def get_notification_link(socket, notification) do
    thread = Hello.Forum.get_thread!(notification.target_id)

    Routes.board_thread_path(socket, :show, thread.board.id, thread)
  end

end
