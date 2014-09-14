defmodule Tty2048.GridTest do
  use ExUnit.Case

  alias Tty2048.Grid

  setup_all do
    :random.seed(1374, 347975, 449264) # make tests deterministic

    {:ok, grid: [
      [4, 0, 2, 2],
      [2, 2, 4, 4],
      [2, 0, 2, 2],
      [0, 2, 0, 2]
    ]}
  end

  test "creation" do
    assert Grid.make(2) == [[0, 0], [2, 0]]
  end

  test "formatting", ctx do
    assert Grid.format(ctx[:grid]) == Tty2048.Grid.Formatter.format(ctx[:grid])
  end

  test "move left", ctx do
    assert Grid.move({:left, ctx[:grid]}) == [
      [4, 4, 0, 0],
      [4, 8, 0, 0],
      [4, 2, 0, 2],
      [4, 0, 0, 0]
    ]
  end

  test "move right", ctx do
    assert Grid.move({:right, ctx[:grid]}) == [
      [0, 0, 4, 4],
      [0, 0, 4, 8],
      [0, 2, 2, 4],
      [0, 0, 0, 4]
    ]
  end

  test "move up", ctx do
    assert Grid.move({:up, ctx[:grid]}) == [
      [4, 4, 2, 2],
      [4, 0, 4, 4],
      [0, 0, 2, 4],
      [2, 0, 0, 0]
    ]
  end

  test "move down", ctx do
    assert Grid.move({:down, ctx[:grid]}) == [
      [0, 0, 0, 2],
      [0, 0, 2, 2],
      [4, 0, 4, 4],
      [4, 4, 2, 4]
    ]
  end
end
