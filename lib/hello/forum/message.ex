defmodule Hello.Forum.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :read, :boolean
    field :subject, :string
    field :content, :string
    belongs_to :sender, Hello.Forum.Member
    belongs_to :receiver, Hello.Forum.Member

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:read, :subject, :content])
    |> validate_required([:read, :subject, :content])
  end
end
