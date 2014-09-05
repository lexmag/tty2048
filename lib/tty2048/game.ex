defmodule Tty2048.Game do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, [name: :game])
  end

  def init(nil) do
    {:ok, Tty2048.Grid.make(4)}
  end

  def move(direction) do
    GenServer.call(:game, {:move, direction})
  end

  def handle_call({:move, direction}, _from, grid) do
    grid = Tty2048.Grid.move(grid, direction)

    {:reply, grid, grid}
  end
end
