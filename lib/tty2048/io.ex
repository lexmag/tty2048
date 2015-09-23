defmodule Tty2048.IO do
  use GenEvent

  alias Tty2048.Game

  def init({%Game{} = game, _args}) do
    print_game(game)
    {:ok, Port.open({:spawn, "tty_sl -c -e"}, [:binary, :eof])}
  end

  def handle_event({:moved, %Game{} = game}, state) do
    print_game(game)
    {:ok, state}
  end

  def handle_event({:game_over, %Game{} = game}, state) do
    Game.Formatter.game_over(game)
    |> IO.write
    {:ok, state}
  end

  def handle_info({pid, {:data, data}}, pid) do
    if side = translate(data), do: Game.move(side)
    {:ok, pid}
  end

  defp translate("\e[A"), do: :up
  defp translate("\e[B"), do: :down
  defp translate("\e[C"), do: :right
  defp translate("\e[D"), do: :left
  defp translate(_other), do: nil

  defp print_game(game) do
    Game.Formatter.format(game)
    |> IO.write
  end
end
