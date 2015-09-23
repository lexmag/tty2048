defmodule Tty2048.Game.FormatterTest do
  use ExUnit.Case

  alias Tty2048.Game
  alias Game.Formatter

  defp format_game(grid, score, fun) do
    fun.(%Game{grid: grid, score: score})
    |> IO.iodata_to_binary
  end

  test "format/1" do
    output =
      "\e[H\e[2J  score: 7\r\n\r\n" <>
      "\e[35m  1k\e[0m\r\n\e[0m"
    assert format_game([[1024]], 7, &Formatter.format/1) == output
  end

  test "game_over/1" do
    output =
      "\e[H\e[2J  score: 7\r\n\r\n\e" <>
      "[2m\e[32m   2\e[0m\e[2m\r\n\e[0m\e[2m\r\n" <>
      "\e[0m    GAME OVER\r\n"
    assert format_game([[2]], 7, &Formatter.game_over/1) == output
  end
end
