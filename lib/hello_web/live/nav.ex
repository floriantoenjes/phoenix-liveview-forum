defmodule HelloWeb.NavLive do
  use Phoenix.LiveComponent
  use HelloWeb, :live_view

  def mount(%{"current_author" => author}, socket) do
    {:ok, socket |> assign(:author, author)}
  end

end
