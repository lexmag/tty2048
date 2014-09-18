defmodule Tty2048.Game do
  alias __MODULE__

  defstruct [:grid, score: 0]

  use GenServer

  alias Tty2048.Grid

  def start_link(size) do
    GenServer.start_link(__MODULE__, size, [name: :game])
  end

  def init(size) do
    {:ok, %Game{grid: Grid.make(size)}, 0}
  end

  def move(direction) do
    GenServer.cast(:game, {:move, direction})
  end

  def handle_cast({:move, direction}, %Game{} = game) do
    {:noreply, move(game, direction), 0}
  end

  def handle_info(:timeout, %Game{grid: grid} = state) do
    Grid.format(grid)
    |> IO.write

    {:noreply, state}
  end

  defp move(%{grid: grid, score: score}, direction) do
    {grid, points} = Grid.move({direction, grid})

    %Game{grid: grid, score: score + points}
  end
end
