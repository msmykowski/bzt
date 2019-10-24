defmodule Bzt.Pool.Supervisor do
  use Supervisor
  alias Bzt.Registry
  alias Bzt.Pool.{ConnectionSupervisor, Coordinator, RequestQueue}

  def start_link(name: name) do
    Supervisor.start_link(__MODULE__, name, name: Registry.via_tuple(__MODULE__, name))
  end

  @impl true
  def init(name) do
    children = [
      {Coordinator, [name: name]},
      {RequestQueue, [name: name]},
      {ConnectionSupervisor, [name: name]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
