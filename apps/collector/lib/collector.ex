defmodule Collector do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: Collector.TaskSupervisor]]),
      worker(Task, [Collector.Worker, :accept, []]),
      worker(Collector.Aggregator, [Collector.Aggregator]),
      worker(Collector.Cleanup, [1000])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Collector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
