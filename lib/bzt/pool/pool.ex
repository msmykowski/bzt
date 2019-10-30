defmodule Bzt.Pool do
  alias Bzt.{PoolsSupervisor, Registry, Request}
  alias Bzt.Pool.{Config, RequestQueue, Supervisor}

  def queue(%Request{} = request, _opts) do
    case fetch_queue(request) do
      {:ok, queue_pid} -> RequestQueue.push(queue_pid, request)
      error -> error
    end
  end

  defp fetch_queue(%Request{host: host}) do
    case Registry.lookup(Supervisor, host) do
      [] ->
        with {:ok, config} <- fetch_config(host),
             {:ok, _pid} <- PoolsSupervisor.start_pool(config),
             [{request_queue, nil}] <- Registry.lookup(RequestQueue, host) do
          {:ok, request_queue}
        else
          error -> error
        end

      [{_connection_supervisor, nil}] ->
        [{request_queue, nil}] = Registry.lookup(RequestQueue, host)
        {:ok, request_queue}
    end
  end

  defp fetch_config(host) do
    config = Application.get_env(:bzt, :host, %{name: host})

    if config do
      {:ok, Config.new(config)}
    else
      {:error, :config_not_set}
    end
  end
end
