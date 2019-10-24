defmodule Bzt.Pool.Connection do
  use GenStage

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  def init(subscribe_to: subscribe_to) do
    {:consumer, :ok, subscribe_to: [{subscribe_to, max_demand: 100}]}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events)
    {:noreply, [], state}
  end
end
