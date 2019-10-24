defmodule Bzt do
  alias Bzt.{Pool, Request}

  def request(params, opts \\ []) do
    params
    |> Request.new()
    |> Pool.queue(opts)
  end
end
