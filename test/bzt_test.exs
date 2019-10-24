defmodule BztTest do
  use ExUnit.Case
  doctest Bzt

  test "greets the world" do
    assert Bzt.hello() == :world
  end
end
