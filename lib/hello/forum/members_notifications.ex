defmodule Hello.Forum.Members_Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members_notifications" do
    belongs_to :member, Hello.Forum.Member
    belongs_to :notification, Hello.Forum.Notification

    timestamps()
  end

end
