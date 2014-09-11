defmodule Tty2048.Driver do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    {:ok, Port.open({:spawn, 'tty_sl -c -e'}, [:eof])}
  end

  def handle_info({pid, {:data, data}}, pid) do
    if direction = translate(data) do
      Tty2048.Game.move(direction)
    end

    {:noreply, pid}
  end

  defp translate('\e[A'), do: :up
  defp translate('\e[B'), do: :down
  defp translate('\e[C'), do: :right
  defp translate('\e[D'), do: :left
  defp translate(_data),  do: nil
end
