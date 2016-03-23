defmodule Collector.Message do
  defstruct [:version, :nsu, :terminal, :external_device, :origin_destiny, :tid, :filler, :message_length, :message]
end

defmodule Collector.BaselineTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "baseline_transaction" do
    field :nsu,      :string
    field :terminal, :string
    field :tid,      :string

    timestamps
  end

  def changeset(bt, params \\ %{}) do
    bt
    |> cast(params, ~w(tid), ~w(nsu terminal))
  end
end

defmodule Collector.BaselineMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "baseline_message" do
    field :foo,   :integer
    belongs_to :baseline_transaction, Collector.BaselineTransaction

    timestamps
  end
end
