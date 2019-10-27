defmodule Bzt.Pool.Config do
  defstruct [:name, min_connections: 4, max_connections: 4]

  def new(params) do
    struct(__MODULE__, params)
  end
end
