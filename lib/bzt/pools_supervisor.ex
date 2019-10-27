defmodule Bzt.PoolsSupervisor do
  use DynamicSupervisor
  alias Bzt.Pool.Supervisor

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_pool(config) do
    DynamicSupervisor.start_child(__MODULE__, {Supervisor, config: config})
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: []
    )
  end
end
