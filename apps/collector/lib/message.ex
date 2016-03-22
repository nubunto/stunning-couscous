defmodule Collector.Message do
  defstruct [:version, :nsu, :terminal, :external_device, :origin_destiny, :tid, :filler, :message_length, :message]
end
