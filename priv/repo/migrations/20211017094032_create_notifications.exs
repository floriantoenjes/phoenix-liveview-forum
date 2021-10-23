defmodule Hello.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :read, :boolean, default: false, null: false
      add :type, :integer
      add :target_id, :integer
      add :resource_name, :string

      timestamps()
    end

    create table(:members_notifications) do
      add :member_id, references(:members)
      add :notification_id, references(:notifications)
    end

  end
end
