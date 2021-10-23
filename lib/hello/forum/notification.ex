defmodule Hello.Forum.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Member

  schema "notifications" do
    field :read, :boolean, default: false
    field :resource_name, :string
    field :target_id, :integer
    field :type, :integer

    many_to_many :receiver, Member, join_through: Hello.Forum.Members_Notification

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:read, :type, :target_id, :resource_name])
    |> validate_required([:read, :type, :target_id, :resource_name])
  end
end
