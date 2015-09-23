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

  test "new/1" do
    assert Grid.new(2) == [[4, 2], [0, 0]]
    assert Grid.new(2) == [[0, 2], [0, 2]]
  end

  test "move/2 left side", ctx do
    assert Grid.move(ctx[:grid], :left) == {
      [[4, 4, 0, 0],
       [4, 8, 0, 0],
       [4, 2, 2, 0],
       [4, 0, 0, 0]], 24
    }
  end

  test "move/2 right side", ctx do
    assert Grid.move(ctx[:grid], :right) == {
      [[0, 0, 4, 4],
       [0, 0, 4, 8],
       [2, 0, 2, 4],
       [0, 0, 0, 4]], 24
    }
  end

  test "move/2 up side", ctx do
    assert Grid.move(ctx[:grid], :up) == {
      [[4, 4, 2, 2],
       [4, 0, 4, 4],
       [0, 0, 2, 4],
       [2, 0, 0, 0]], 12
    }
  end

  test "move/2 down side", ctx do
    assert Grid.move(ctx[:grid], :down) == {
      [[0, 0, 0, 2],
       [0, 0, 2, 2],
       [4, 0, 4, 4],
       [4, 4, 2, 4]], 12
    }
  end

  test "make/2 no points" do
    grid = [[0, 0], [2, 4]]

    assert Grid.move(grid, :left) == {grid, 0}
  end

  test "has_move?/1" do
    assert Grid.has_move?([[0, 2]])
    assert Grid.has_move?([[2, 0]])
    assert Grid.has_move?([[0], [2]])
    assert Grid.has_move?([[2], [0]])

    refute Grid.has_move?([[4, 2]])
    refute Grid.has_move?([[2, 4]])
    refute Grid.has_move?([[4], [2]])
    refute Grid.has_move?([[2], [4]])
  end
end
