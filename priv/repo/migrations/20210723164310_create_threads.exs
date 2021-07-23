defmodule Hello.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :title, :string
      add :board_id, references(:boards, on_delete: :nothing)

      timestamps()
    end

  end
end
