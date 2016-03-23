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

  ## Client

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  ## Server.

  def init(:ok) do
    {:ok, nil}
  end

  def handle_info({:process, payload}, _) do
    spawn(fn ->
      for {tid, transactions} <- payload,
          trans <- transactions do
            #IO.puts "Processing #{Map.get(trans, :external_device)}"
      end
    end)
    {:noreply, nil}
  end
end
