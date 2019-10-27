defmodule Bzt.Pool.ConnectionSupervisor do
  use DynamicSupervisor
  alias Bzt.Registry
  alias Bzt.Pool.{Connection, RequestQueue}

  def start_link([config: config] = opts) do
    name = config.name

    connection_supervisor =
      DynamicSupervisor.start_link(__MODULE__, config, name: Registry.via_tuple(__MODULE__, name))

    Enum.each(1..config.min_connections, fn _i ->
      {:ok, _child_pid} = start_connection(name, [])
    end)

    connection_supervisor
  end

  def start_connection(name, args) do
    [{connection_supervisor, nil}] = Registry.lookup(__MODULE__, name)
    [{request_queue, nil}] = Registry.lookup(RequestQueue, name)

    spec = {Connection, Keyword.put(args, :subscribe_to, request_queue)}
    DynamicSupervisor.start_child(connection_supervisor, spec)
  end

  @impl true
  def init(config) do
    DynamicSupervisor.init(
      max_children: config.max_connections,
      strategy: :one_for_one,
      extra_arguments: []
    )
  end
end
