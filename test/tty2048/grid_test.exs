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

  test "creation" do
    assert Grid.make(2) == [[0, 0], [0, 0]]
  end

  test "formatting", ctx do
    assert Grid.format(ctx[:grid]) == Tty2048.Grid.Formatter.format(ctx[:grid])
  end

  test "move left", ctx do
    assert Grid.move(ctx[:grid], :left) == [
      [4, 4, 0, 0],
      [4, 8, 0, 0],
      [4, 2, 0, 0],
      [4, 0, 0, 0]
    ]
  end

  test "move right", ctx do
    assert Grid.move(ctx[:grid], :right) == [
      [0, 0, 4, 4],
      [0, 0, 4, 8],
      [0, 0, 2, 4],
      [0, 0, 0, 4]
    ]
  end

  test "move up", ctx do
    assert Grid.move(ctx[:grid], :up) == [
      [4, 4, 2, 2],
      [4, 0, 4, 4],
      [0, 0, 2, 4],
      [0, 0, 0, 0]
    ]
  end

  test "move down", ctx do
    assert Grid.move(ctx[:grid], :down) == [
      [0, 0, 0, 0],
      [0, 0, 2, 2],
      [4, 0, 4, 4],
      [4, 4, 2, 4]
    ]
  end
end
