defmodule HelloWeb.NotificationLive.Index do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Notification

  @impl true
  def mount(_params, %{"current_author" => author}, socket) do
    {:ok, socket |> assign(:notifications, list_notifications()) |> assign(:author, author)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Notification")
    |> assign(:notification, Forum.get_notification!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Notification")
    |> assign(:notification, %Notification{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notifications")
    |> assign(:notification, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notification = Forum.get_notification!(id)
    {:ok, _} = Forum.delete_notification(notification)

    {:noreply, assign(socket, :notifications, list_notifications())}
  end

  defp list_notifications do
    Forum.list_notifications()
  end
end
