defmodule Hello.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :read, :boolean, default: false, null: false
      add :subject, :string
      add :content, :string

      add :sender_id, references(:members, on_delete: :nothing)
      add :receiver_id, references(:members, on_delete: :nothing)

      timestamps()
    end

  end
end
