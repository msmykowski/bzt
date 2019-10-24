defmodule Bzt.Registry do
  def via_tuple(module, name) do
    {:via, Registry, {__MODULE__, {module, name}}}
  end

  def lookup(module, name) do
    Registry.lookup(__MODULE__, {module, name})
  end
end
