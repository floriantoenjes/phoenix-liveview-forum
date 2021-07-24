defmodule Hello.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Thread
  alias Hello.Forum.Member

  schema "posts" do
    field :content, :string
    belongs_to :thread, Thread
    belongs_to :author, Member, foreign_key: :author_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
