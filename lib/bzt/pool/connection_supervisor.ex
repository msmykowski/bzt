defmodule Bzt.Pool.ConnectionSupervisor do
  use DynamicSupervisor
  alias Bzt.Registry
  alias Bzt.Pool.{Connection, RequestQueue}

  def start_link(config: config) do
    name = config.name

    connection_supervisor =
      DynamicSupervisor.start_link(__MODULE__, config, name: Registry.via_tuple(__MODULE__, name))

    Enum.each(1..config.min_connections, fn _i ->
      {:ok, _child_pid} = start_connection(name, [])
    end)

    connection_supervisor
  end

  def start_connection(name, args) do
    with connection_supervisor when is_pid(connection_supervisor) <-
           fetch_connection_supervisor(name),
         request_queue when is_pid(request_queue) <- RequestQueue.fetch_request_queue(name) do
      spec = {Connection, Keyword.put(args, :subscribe_to, request_queue)}
      DynamicSupervisor.start_child(connection_supervisor, spec)
    else
      error -> {:error, :connection_failed_to_start}
    end
  end

  @impl true
  def init(config) do
    DynamicSupervisor.init(
      max_children: config.max_connections,
      strategy: :one_for_one,
      extra_arguments: []
    )
  end

  def fetch_connection_supervisor(name) do
    case Registry.lookup(__MODULE__, name) do
      [] -> nil
      [{process, _v}] -> process
    end
  end
end
