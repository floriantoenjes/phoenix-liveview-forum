defmodule HelloWeb.BoardsLive do
  use HelloWeb, :live_view

  def mount(_params, %{"boards" => boards}, socket) do
    {:ok, assign(socket, :boards, boards)}
  end

end