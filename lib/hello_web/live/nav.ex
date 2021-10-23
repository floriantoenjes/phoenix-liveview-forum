defmodule HelloWeb.NavLive do
  use Phoenix.LiveComponent
  use HelloWeb, :live_view

  def mount(socket) do
    HelloWeb.Endpoint.subscribe("threads")
    notifications = Hello.Forum.list_notifications()
    {:ok, socket |> assign(:notifications, notifications)}
  end

  def get_notification_link(socket, notification) do
    thread = Hello.Forum.get_thread!(notification.target_id)

    Routes.board_thread_path(socket, :show, thread.board.id, thread)
  end

end
