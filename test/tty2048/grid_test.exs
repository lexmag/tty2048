defmodule Tty2048.GridTest do
  use ExUnit.Case

  setup_all do
    {:ok, grid: [
      [4, 0, 2, 2],
      [2, 2, 4, 4],
      [2, 0, 2, 2],
      [0, 2, 0, 2]
    ]}
  end

  test "move left", context do
    assert Tty2048.Grid.move(context[:grid], :left) == [
      [4, 4, 0, 0],
      [4, 8, 0, 0],
      [4, 2, 0, 0],
      [4, 0, 0, 0]
    ]
  end

  test "move right", context do
    assert Tty2048.Grid.move(context[:grid], :right) == [
      [0, 0, 4, 4],
      [0, 0, 4, 8],
      [0, 0, 2, 4],
      [0, 0, 0, 4]
    ]
  end

  test "move up", context do
    assert Tty2048.Grid.move(context[:grid], :up) == [
      [4, 4, 2, 2],
      [4, 0, 4, 4],
      [0, 0, 2, 4],
      [0, 0, 0, 0]
    ]
  end

  test "move down", context do
    assert Tty2048.Grid.move(context[:grid], :down) == [
      [0, 0, 0, 0],
      [0, 0, 2, 2],
      [4, 0, 4, 4],
      [4, 4, 2, 4]
    ]
  end
end
