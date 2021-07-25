defmodule Hello.Forum.CreateThread do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :title, :string
    field :content, :string
  end

  @doc false
  def changeset(create_thread, attrs) do
    create_thread
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
