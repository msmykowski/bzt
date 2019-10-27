defmodule Bzt.Request do
  defstruct host: "example.com", path: "/", verb: "GET"

  def new(params) do
    struct(__MODULE__, params)
  end
end
