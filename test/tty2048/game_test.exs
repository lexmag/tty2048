defmodule Tty2048.GameTest do
  use ExUnit.Case

  alias Tty2048.Game

  import ExUnit.CaptureIO

  defp make_game(grid, score) do
    %Game{grid: grid, score: score}
  end

  defp capture_game_io(grid, action) do
    capture_io fn ->
      {:ok, _} = Game.start_link(make_game(grid, 1))
      action.()
      :timer.sleep(10)
    end
  end

  defp game_to_binary(grid, score) do
    make_game(grid, score)
    |> Game.Formatter.format
    |> IO.iodata_to_binary
  end

  setup do # make tests deterministic
    {:ok, _} = Tty2048.Random.start_link({23242, 27726, 24113})
    :ok
  end

  test "creation" do
    output = capture_game_io [[4, 4]], fn ->
      :timer.sleep(10)
    end

    assert output == game_to_binary([[4, 4]], 1)
  end

  test "move left" do
    output = capture_game_io [[2, 2]], fn ->
      Game.move(:left)
    end

    assert output == game_to_binary([[4, 2]], 5)
  end

  test "move right" do
    output = capture_game_io [[2, 2]], fn ->
      Game.move(:right)
    end

    assert output == game_to_binary([[2, 4]], 5)
  end

  test "move up" do
    output = capture_game_io [[2], [2]], fn ->
      Game.move(:up)
    end

    assert output == game_to_binary([[4], [2]], 5)
  end

  test "move down" do
    output = capture_game_io [[2], [2]], fn ->
      Game.move(:down)
    end

    assert output == game_to_binary([[2], [4]], 5)
  end
end
