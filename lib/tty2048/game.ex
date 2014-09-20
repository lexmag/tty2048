defmodule Tty2048.Game do
  alias __MODULE__

  defstruct [:grid, score: 0]

  use GenServer

  alias Tty2048.Grid

  def new(size),
    do: %Game{grid: Grid.make(size)}

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: :game])
  end

  def init(%Game{} = state) do
    {:ok, state, 1}
  end

  def move(direction) do
    GenServer.cast(:game, {:move, direction})
  end

  def handle_cast({:move, direction}, %Game{} = state) do
    {:noreply, move(state, direction), 0}
  end

  def handle_info(:timeout, %Game{} = state) do
    format(state)
    |> IO.write

    {:noreply, state}
  end

  defp move(%{grid: grid, score: score}, direction) do
    {grid, points} = Grid.move({direction, grid})

    %Game{grid: grid, score: score + points}
  end

  defp format(%{grid: grid}) do
    [IO.ANSI.home, IO.ANSI.clear, Grid.format(grid), IO.ANSI.reset]
  end
end
