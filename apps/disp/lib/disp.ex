defmodule Disp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Disp.Server, [Disp.Server])
    ]

    opts = [strategy: :one_for_one, name: Disp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Disp.Server do
  use GenServer

  # client

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:ok, 0}
  end

  def handle_info({:process, %{tid: something}}, processed) do
    spawn(fn ->
      :timer.sleep 5000
    end)
    IO.puts "Processed #{processed}"
    {:noreply, processed + 1}
  end
end
