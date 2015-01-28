defmodule Tty2048.Driver do
  use GenEvent

  alias Tty2048.Game

  def init({%Game{} = game, _args}) do
    write(game)
    {:ok, Port.open({:spawn, "tty_sl -c -e"}, [:binary, :eof])}
  end

  def handle_event(%Game{} = game, state) do
    write(game)
    {:ok, state}
  end

  def handle_info({pid, {:data, data}}, pid) do
    if action = translate(data), do: Game.move(action)

    {:ok, pid}
  end

  defp translate("\e[A"), do: :up
  defp translate("\e[B"), do: :down
  defp translate("\e[C"), do: :right
  defp translate("\e[D"), do: :left
  defp translate(_other), do: nil

  defp write(game) do
    Game.Formatter.format(game)
    |> IO.write
  end
end
