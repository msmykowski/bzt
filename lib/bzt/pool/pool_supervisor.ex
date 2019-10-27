defmodule Bzt.Pool.Supervisor do
  use Supervisor
  alias Bzt.Registry
  alias Bzt.Pool.{ConnectionSupervisor, Coordinator, RequestQueue}

  def start_link(config: config = opts) do
    Supervisor.start_link(__MODULE__, config, name: Registry.via_tuple(__MODULE__, config.name))
  end

  @impl true
  def init(config) do
    children = [
      {Coordinator, [name: config.name]},
      {RequestQueue, [name: config.name]},
      {ConnectionSupervisor, [config: config]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
