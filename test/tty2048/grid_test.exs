defmodule Tty2048.GridTest do
  use ExUnit.Case

  alias Tty2048.Grid

  setup_all do
    {:ok, grid: [
      [4, 0, 2, 2],
      [2, 2, 4, 4],
      [2, 0, 2, 2],
      [0, 2, 0, 2]
    ]}
  end

  setup do # make tests deterministic
    :random.seed(23242, 27726, 24113)
    :ok
  end

  test "creation" do
    assert Grid.new(2) == [[4, 2], [0, 0]]
    assert Grid.new(2) == [[0, 2], [0, 2]]
  end

  test "move left", ctx do
    assert Grid.move({:left, ctx[:grid]}) == {
      [[4, 4, 0, 0],
       [4, 8, 0, 0],
       [4, 2, 2, 0],
       [4, 0, 0, 0]], 24
    }
  end

  test "move right", ctx do
    assert Grid.move({:right, ctx[:grid]}) == {
      [[0, 0, 4, 4],
       [0, 0, 4, 8],
       [2, 0, 2, 4],
       [0, 0, 0, 4]], 24
    }
  end

  test "move up", ctx do
    assert Grid.move({:up, ctx[:grid]}) == {
      [[4, 4, 2, 2],
       [4, 0, 4, 4],
       [0, 0, 2, 4],
       [2, 0, 0, 0]], 12
    }
  end

  test "move down", ctx do
    assert Grid.move({:down, ctx[:grid]}) == {
      [[0, 0, 0, 2],
       [0, 0, 2, 2],
       [4, 0, 4, 4],
       [4, 4, 2, 4]], 12
    }
  end

  test "make no move" do
    grid = [[0, 0], [2, 4]]

    assert Grid.move({:left, grid}) == {grid, 0}
  end
end
