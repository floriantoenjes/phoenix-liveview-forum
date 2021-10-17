defmodule HelloWeb.NotificationLive.Show do
  use HelloWeb, :live_view

  alias Hello.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:notification, Forum.get_notification!(id))}
  end

  defp page_title(:show), do: "Show Notification"
  defp page_title(:edit), do: "Edit Notification"
end
