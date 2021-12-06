defmodule HelloWeb.MessageLive.Index do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Message

  @impl true
  def mount(_params, %{"current_author" => author}, socket) do
    {:ok, socket |> assign(:messages, list_messages()) |> assign(:author, author)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Forum.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Forum.get_message!(id)
    {:ok, _} = Forum.delete_message(message)

    {:noreply, assign(socket, :messages, list_messages())}
  end

  defp list_messages do
    Forum.list_messages()
  end
end
