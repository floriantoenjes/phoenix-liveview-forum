defmodule Hello.Forum.Member do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Thread
  alias Hello.Forum.Post

  schema "members" do
    field :role, :string
    field :signature, :string

    belongs_to :user, Hello.Accounts.User

    has_many :threads, Thread
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :signature])
    |> validate_required([:role, :signature])
    |> unique_constraint(:user_id)
  end
end
