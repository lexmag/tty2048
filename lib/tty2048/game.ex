defmodule Tty2048.Game do
  defstruct [:grid, score: 0]

  use GenServer

  alias Tty2048.Grid

  def new(size),
    do: %__MODULE__{grid: Grid.new(size)}

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: :game])
  end

  def init(%__MODULE__{} = state) do
    {:ok, state, 1}
  end

  def move(direction) do
    GenServer.cast(:game, {:move, direction})
  end

  def handle_cast({:move, direction}, %__MODULE__{} = state) do
    {:noreply, move(state, direction), 0}
  end

  def handle_info(:timeout, %__MODULE__{} = state) do
    format(state)
    |> IO.write

    {:noreply, state}
  end

  defp move(%{grid: grid, score: score}, direction) do
    {grid, points} = Grid.move({direction, grid})

    %__MODULE__{grid: grid, score: score + points}
  end

  defp format(%{grid: grid}) do
    [IO.ANSI.home, IO.ANSI.clear, Grid.format(grid), IO.ANSI.reset]
  end
end
