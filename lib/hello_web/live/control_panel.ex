defmodule HelloWeb.ControlPanelLive do
  use HelloWeb, :live_view

  alias Hello.Forum

  def mount(_params, %{"current_author" => author}, socket) do

    subscribed_threads = Forum.list_subscribed_threads(author)

    {:ok, socket |> assign(:author, author) |> assign(:subscribed_threads, subscribed_threads)}
  end

  def handle_event("unsubscribe", %{"thread-id" => thread_id}, socket) do
    Forum.unsubscribe_from_thread(Forum.get_thread!(thread_id), socket.assigns.author)

    subscribed_threads = Forum.list_subscribed_threads(socket.assigns.author)

    {:noreply, socket |> assign(:subscribed_threads, subscribed_threads)}
  end

end