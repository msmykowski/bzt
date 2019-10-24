defmodule Bzt.Pool.ConnectionSupervisor do
  use DynamicSupervisor
  alias Bzt.Registry
  alias Bzt.Pool.{Connection, RequestQueue}

  def start_link([name: name] = opts) do
    opts = Keyword.update!(opts, :name, &Registry.via_tuple(__MODULE__, &1))
    connection_supervisor = DynamicSupervisor.start_link(__MODULE__, :ok, opts)
    {:ok, _child_pid} = start_connection(name, [])

    connection_supervisor
  end

  def start_connection(name, args) do
    [{connection_supervisor, nil}] = Registry.lookup(__MODULE__, name)
    [{request_queue, nil}] = Registry.lookup(RequestQueue, name)

    spec = {Connection, Keyword.put(args, :subscribe_to, request_queue)}
    DynamicSupervisor.start_child(connection_supervisor, spec)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: []
    )
  end
end
