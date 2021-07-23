defmodule Hello.Forum.Board do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Thread

  schema "boards" do
    field :name, :string
    has_many :threads, Thread

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
