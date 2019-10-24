defmodule Bzt.Pool.RequestQueue do
  use GenStage
  alias Bzt.Registry

  def start_link(opts) do
    opts = Keyword.update!(opts, :name, &Registry.via_tuple(__MODULE__, &1))
    GenStage.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    queue = Enum.reduce([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], :queue.new(), &:queue.in(&1, &2))
    {:producer, {queue, 0}}
  end

  def push(pid, event) do
    GenStage.cast(pid, {:push, event})
  end

  def handle_cast({:push, event}, {queue, pending_demand}) do
    queue = :queue.in(event, queue)
    dispatch_events(queue, pending_demand, [])
  end

  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  defp dispatch_events(queue, 0, events) do
    {:noreply, Enum.reverse(events), {queue, 0}}
  end

  defp dispatch_events(queue, demand, events) do
    case :queue.out(queue) do
      {{:value, event}, queue} ->
        dispatch_events(queue, demand - 1, [event | events])

      {:empty, queue} ->
        {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
