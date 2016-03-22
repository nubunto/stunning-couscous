defmodule Collector.Worker do
  require Logger

  def accept do
    port = Application.fetch_env!(:collector, :port)
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Collector.TaskSupervisor, fn ->
      serve(client)
    end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop(socket)
  end

  defp serve(socket) do
    data = case read_line(socket) do
      {:ok, data} ->
        data
      {:error, :closed} ->
        exit(:shutdown)
    end

    data |> Parser.parse |> inspect |> IO.puts
    write_line(data, socket)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(line, socket) do
    :gen_tcp.send socket, line
  end

end
