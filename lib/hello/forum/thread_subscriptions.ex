defmodule Hello.Forum.Thread_Subscriptions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members_subscribed_threads" do
    belongs_to :member, Hello.Forum.Member
    belongs_to :thread, Hello.Forum.Thread
  end

end
