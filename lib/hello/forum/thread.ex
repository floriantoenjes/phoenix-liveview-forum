defmodule Hello.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Board
  alias Hello.Forum.Post
  alias Hello.Forum.Member

  schema "threads" do
    field :title, :string
    belongs_to :board, Board
    has_many :posts, Post
    belongs_to :author, Member, foreign_key: :author_id

    many_to_many :subscribed_users, Member, join_through: "members_subscribed_threads"

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
