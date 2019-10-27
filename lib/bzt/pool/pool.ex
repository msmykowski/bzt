defmodule Bzt.Pool do
  alias Bzt.{PoolsSupervisor, Registry, Request}
  alias Bzt.Pool.{Config, RequestQueue, Supervisor}

  def queue(%Request{} = request, _opts) do
    queue_pid = get_or_start_pool(request)
    RequestQueue.push(queue_pid, request)
  end

  defp get_or_start_pool(%Request{host: host}) do
    case Registry.lookup(Supervisor, host) do
      [] ->
        IO.inspect("starting pool....")
        config = Config.new(Application.get_env(:bzt, :host, %{name: host}))
        {:ok, _pid} = PoolsSupervisor.start_pool(config)
        [{request_queue, nil}] = Registry.lookup(RequestQueue, host)
        request_queue

      [{_connection_supervisor, nil}] ->
        [{request_queue, nil}] = Registry.lookup(RequestQueue, host)
        request_queue
    end
  end
end
