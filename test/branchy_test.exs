defmodule BranchyTest do
  use ExUnit.Case
  doctest Branchy

  test "greets the world" do
    assert Branchy.hello() == :world
  end
end
