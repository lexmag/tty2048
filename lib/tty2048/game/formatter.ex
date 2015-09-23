defmodule Tty2048.Game.Formatter do
  alias IO.ANSI

  def format(%Tty2048.Game{} = game) do
    [ANSI.home, ANSI.clear,
     format_score(game),
     format_grid(game),
     ANSI.reset]
  end

  def game_over(game) do
    output =
      format(game)
      |> IO.chardata_to_string
      |> String.replace("\r\n\r\n", ANSI.faint, insert_replaced: 0)
      |> String.replace(ANSI.reset, ANSI.faint, insert_replaced: 0)

    [output, "\r\n", ANSI.reset, "    GAME OVER\r\n"]
  end

  defp format_score(%{score: score}) do
    ["  score: ", Integer.to_string(score), "\r\n\r\n"]
  end

  defp format_grid(%{grid: grid}) do
    Tty2048.Grid.Formatter.format(grid)
  end
end
