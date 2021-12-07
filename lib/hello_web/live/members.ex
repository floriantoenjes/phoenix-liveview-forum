defmodule HelloWeb.MembersLive do
  use HelloWeb, :live_view

  alias Hello.Forum
  alias Hello.Forum.Member

  def mount(_params, session, socket) do
    users = Hello.Accounts.list_users()
    {:ok, Forum.assign_session_defaults_to_socket(socket, session) |> assign(:users, users)}
  end
end