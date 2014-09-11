defmodule Tty2048.Game do
  use GenServer

  alias Tty2048.Grid

  def start_link(size) do
    GenServer.start_link(__MODULE__, size, [name: :game])
  end

  def init(size) do
    {:ok, Grid.make(size), 0}
  end

  def move(direction) do
    GenServer.cast(:game, {:move, direction})
  end

  def handle_cast({:move, direction}, grid) do
    {:noreply, Grid.move(grid, direction), 0}
  end

  def handle_info(:timeout, grid) do
    Grid.format(grid)
    |> IO.write

    {:noreply, grid}
  end
end
