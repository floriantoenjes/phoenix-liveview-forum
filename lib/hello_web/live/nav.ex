defmodule HelloWeb.NavLive do
  use Phoenix.LiveComponent
  use HelloWeb, :live_view

  def mount(socket) do
    notifications = [Hello.Forum.get_notification!(1)]
    {:ok, socket |> assign(:notifications, notifications)}
  end

end
