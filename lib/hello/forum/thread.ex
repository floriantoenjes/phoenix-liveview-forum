defmodule Hello.Forum.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Forum.Board

  schema "threads" do
    field :title, :string
    belongs_to :board, Board

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
