defmodule Hello.Repo.Migrations.CreateThreadSubscriptions do
  use Ecto.Migration

  def change do
    create table(:members_subscribed_threads) do
      add :member_id, references(:members)
      add :thread_id, references(:threads)
    end
  end
end
