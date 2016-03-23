defmodule Collector.Repo.Migrations.AddBaselineMessage do
  use Ecto.Migration

  def change do
      create table :baseline_message do
        add :foo,   :integer
        add :baseline_transaction_id, references: :baseline_transaction

        timestamps
      end
  end
end
