defmodule HelloWeb.MessageLive.Show do
  use HelloWeb, :live_view

  alias Hello.Forum

  @impl true
  def mount(_params, session, socket) do
    {:ok, Forum.assign_session_defaults_to_socket(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:message, Forum.get_message!(id))}
  end

  defp page_title(:show), do: "Show Message"
  defp page_title(:edit), do: "Edit Message"
end
