defmodule Tty2048.GameTest do
  use ExUnit.Case

  alias Tty2048.Game

  import ExUnit.CaptureIO

  defp capture_game_io(grid, action) do
    capture_io fn ->
      {:ok, _} = Game.start_link(%Game{grid: grid})
      action.()
      :timer.sleep(10)
    end
  end

  setup do
    :random.seed(23242, 27726, 24113) # make tests deterministic
    :ok
  end

  test "creation" do
    output = capture_game_io [[4, 4]], fn ->
      :timer.sleep(10)
    end

    assert output == "\e[H\e[2J\e[33m   4\e[33m   4\r\n\e[0m"
  end

  test "move left" do
    output = capture_game_io [[2, 2]], fn ->
      Game.move(:left)
    end

    assert output == "\e[H\e[2J\e[33m   4\e[32m   2\r\n\e[0m"
  end

  test "move right" do
    output = capture_game_io [[2, 2]], fn ->
      Game.move(:right)
    end

    assert output == "\e[H\e[2J\e[32m   2\e[33m   4\r\n\e[0m"
  end

  test "move up" do
    output = capture_game_io [[2], [2]], fn ->
      Game.move(:up)
    end

    assert output == "\e[H\e[2J\e[33m   4\r\n\e[32m   2\r\n\e[0m"
  end

  test "move down" do
    output = capture_game_io [[2], [2]], fn ->
      Game.move(:down)
    end

    assert output == "\e[H\e[2J\e[32m   2\r\n\e[33m   4\r\n\e[0m"
  end
end
