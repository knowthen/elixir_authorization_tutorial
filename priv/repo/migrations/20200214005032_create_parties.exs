defmodule WaitList.Repo.Migrations.CreateParties do
  use Ecto.Migration

  def change do
    create table(:parties) do
      add :name, :string
      add :size, :integer

      add :status, :integer

      timestamps()
    end

    create index(:parties, [:status])
  end
end
