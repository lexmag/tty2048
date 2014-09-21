defmodule Tty2048.Game.Formatter do
  def format(%Tty2048.Game{} = game) do
    [IO.ANSI.home, IO.ANSI.clear,
     format_score(game),
     format_grid(game),
     IO.ANSI.reset]
  end

  defp format_score(%{score: score}) do
    ["  score: ", Integer.to_string(score), "\r\n\r\n"]
  end

  defp format_grid(%{grid: grid}) do
    Tty2048.Grid.format(grid)
  end
end
