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

  def move(side) do
    GenServer.cast(__MODULE__, {:move, side})
  end

  def handle_call(:peek, _from, {_, %__MODULE__{}} = game) do
    {:reply, game, game}
  end

  def handle_cast({:move, side}, {manager, %__MODULE__{} = game}) do
    case move(game, side) do
      {true, game} ->
        GenEvent.notify(manager, {:moved, game})
        {:noreply, {manager, game}}
      {false, game} ->
        GenEvent.notify(manager, {:game_over, game})
        {:noreply, {manager, game}}
    end
  end

  defp new(%__MODULE__{} = game), do: game

  defp new(size) when is_integer(size) do
    %__MODULE__{grid: Grid.new(size)}
  end

  defp move(%{grid: grid, score: score}, side) do
    {grid, points} = Grid.move(grid, side)
    game = %__MODULE__{grid: grid, score: score + points}
    {Grid.has_move?(grid), game}
  end
end
