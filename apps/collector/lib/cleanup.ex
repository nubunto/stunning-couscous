defmodule Collector.Cleanup do
  def start_link(seconds) do
    :timer.apply_interval(seconds, Collector.Cleanup, :mark, [])
    {:ok, self}
  end

  def mark do
    sent =
      Collector.Aggregator.get
      |> Enum.group_by(&(&1.tid))
    send Disp.Server, {:process, sent}
    Enum.each sent, &(Collector.Aggregator.remove(&1))
    IO.puts "Aggregator count: #{Collector.Aggregator.get |> Enum.count}"
  end
end
