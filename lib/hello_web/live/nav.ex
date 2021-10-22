defmodule HelloWeb.NavLive do
  use Phoenix.LiveComponent
  use HelloWeb, :live_view

  def mount(socket) do
    notifications = Hello.Forum.list_notifications()
    {:ok, socket |> assign(:notifications, notifications)}
  end

end
