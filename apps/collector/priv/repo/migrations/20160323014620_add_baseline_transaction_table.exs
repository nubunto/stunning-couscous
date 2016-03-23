defmodule Collector.Repo.Migrations.AddBaselineTransactionTable do
  use Ecto.Migration

  def change do
    create table(:baseline_transaction) do
      add :nsu, :string
      add :terminal, :string
      add :tid, :string

      timestamps
    end
  end
end
