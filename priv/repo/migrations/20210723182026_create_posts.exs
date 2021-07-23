defmodule Hello.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text
      add :thread_id, references(:threads, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:thread_id])
  end
end
