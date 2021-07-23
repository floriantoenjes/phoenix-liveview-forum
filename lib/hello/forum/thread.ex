defmodule Hello.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Board
  alias Hello.Forum.Post

  schema "threads" do
    field :title, :string
    belongs_to :board, Board
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
