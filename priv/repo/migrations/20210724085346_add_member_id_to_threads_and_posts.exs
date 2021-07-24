defmodule Hello.Repo.Migrations.AddMemberIdToThreadsAndPosts do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      add :author_id, references(:members, on_delete: :nothing), null: false
    end

    create index(:threads, [:author_id])

    alter table(:posts) do
      add :author_id, references(:members, on_delete: :nothing), null: false
    end

    create index(:posts, [:author_id])
  end
end
