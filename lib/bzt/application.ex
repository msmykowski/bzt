defmodule Bzt.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Bzt.PoolsSupervisor, []},
      {Registry, keys: :unique, name: Bzt.Registry}
    ]

    opts = [strategy: :one_for_one, name: Bzt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
