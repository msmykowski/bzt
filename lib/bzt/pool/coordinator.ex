defmodule Bzt.Pool.Coordinator do
  use GenServer
  alias Bzt.Registry

  def start_link(opts) do
    opts = Keyword.update!(opts, :name, &Registry.via_tuple(__MODULE__, &1))
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, :ok}
  end
end
