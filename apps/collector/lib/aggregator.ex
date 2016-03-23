defmodule Collector.Aggregator do
  use GenServer

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def push(message) do
    GenServer.cast(__MODULE__, {:push, message})
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def remove(tid) do
    GenServer.cast(__MODULE__, {:remove, tid})
  end

  ## Server API

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast({:push, message}, state) do
    {:noreply, [message|state]}
  end

  def handle_cast({:remove, tid}, messages) do
    {:noreply, Enum.filter(messages, &(&1.tid == tid))}
  end

  def handle_call(:get, _from, messages) do
    {:reply, messages, messages}
  end
end
