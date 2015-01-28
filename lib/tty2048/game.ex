defmodule Tty2048.Game do
  defstruct [:grid, score: 0]

  use GenServer

  alias Tty2048.Grid

  def start_link(from) do
    GenServer.start_link(__MODULE__, from, [name: __MODULE__])
  end

  def init(from) do
    :random.seed(:os.timestamp)
    {:ok, manager} = GenEvent.start_link
    {:ok, {manager, new(from)}}
  end

  def peek() do
    GenServer.call(__MODULE__, :peek)
  end

  def move(direction) do
    GenServer.cast(__MODULE__, {:move, direction})
  end

  def handle_call(:peek, _from, {_, %__MODULE__{}} = state) do
    {:reply, state, state}
  end

  def handle_cast({:move, direction}, {manager, %__MODULE__{} = game}) do
    game = move(game, direction)
    GenEvent.notify(manager, game)

    {:noreply, {manager, game}, 0}
  end

  defp new(%__MODULE__{} = state), do: state

  defp new(size) when is_integer(size) do
    %__MODULE__{grid: Grid.new(size)}
  end

  defp move(%{grid: grid, score: score}, direction) do
    {grid, points} = Grid.move({direction, grid})

    %__MODULE__{grid: grid, score: score + points}
  end
end
