defmodule Hello.Repo.Migrations.AddTimestampsToMembersNotifications do
  use Ecto.Migration

  def change do
    alter table(:members_notifications) do
      timestamps()
    end
  end
end
