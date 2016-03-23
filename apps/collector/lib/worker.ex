defmodule Collector.Worker do
  require Logger
  alias Collector.Parser

  def accept do
    port = Application.fetch_env!(:collector, :port)
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Collector.TaskSupervisor, fn ->
      {:ok, buffer} = Agent.start_link(fn -> <<>> end)
      serve(client, buffer)
    end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop(socket)
  end

  defp serve(socket, buffer) do
    data = case read_line(socket) do
      {:ok, <<header::size(16), data::binary>>} ->
        buffered = Agent.get(buffer, &(&1))
        if byte_size(data) < header && byte_size(buffered) < byte_size(data) do
          Agent.update(buffer, fn b -> <<b::bitstring, data::bitstring>> end)
          serve(socket, buffer)
        else
          Agent.update(buffer, fn _ -> <<>> end)
          buffered <> data
        end
      {:error, :closed} ->
        exit(:shutdown)
    end

    send Disp.Server, {:process, Parser.parse(data)}
    serve(socket, buffer)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

end
