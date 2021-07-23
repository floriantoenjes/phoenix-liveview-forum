defmodule Hello.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Thread

  schema "posts" do
    field :content, :string
    belongs_to :thread, Thread

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
