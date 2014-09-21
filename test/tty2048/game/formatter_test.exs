defmodule Tty2048.Game.FormatterTest do
  use ExUnit.Case

  defp format_game(grid, score) do
    %Tty2048.Game{grid: grid, score: score}
    |> Tty2048.Game.Formatter.format
    |> IO.iodata_to_binary
  end

  test "format" do
    assert format_game([[1024]], 7) == "\e[H\e[2J  score: 7\r\n\r\n\e[35m  1k\r\n\e[0m"
  end
end
