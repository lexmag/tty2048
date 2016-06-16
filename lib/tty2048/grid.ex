defmodule Tty2048.Grid do
  @sides [:up, :down, :right, :left]

  def new(size) when size > 0 do
    make_grid(size)
    |> seed |> seed
  end

  def move(grid, side)
  when is_list(grid) and side in @sides do
    case try_move(grid, side) do
      :noop -> {grid, 0}
      {:ok, grid, points} ->
        {seed(grid), points}
    end
  end

  def has_move?(grid) do
    Enum.any?(@sides, &(try_move(grid, &1) != :noop))
  end

  defp try_move(grid, side) do
    case do_move(grid, side) do
      {^grid, _} -> :noop
      {grid, points} ->
        {:ok, grid, points}
    end
  end

  defp do_move(grid, :left) do
    collapse(grid)
    |> compose(&Enum.reverse(&1, &2))
  end

  defp do_move(grid, :right) do
    Enum.map(grid, &Enum.reverse/1)
    |> collapse
    |> compose(&(&2 ++ &1))
  end

  defp do_move(grid, :up) do
    transpose(grid)
    |> do_move(:left)
    |> transpose
  end

  defp do_move(grid, :down) do
    transpose(grid)
    |> do_move(:right)
    |> transpose
  end

  defp make_grid(size) do
    for _ <- 1..size, do: make_row(size)
  end

  defp make_row(size) do
    for _ <- 1..size, do: 0
  end

  defp compose(chunks, fun) do
    Enum.map_reduce chunks, 0, fn
      {acc, tail, points}, sum -> {fun.(acc, tail), sum + points}
    end
  end

  defp transpose({grid, points}),
    do: {transpose(grid), points}

  defp transpose(grid, acc \\ [])

  defp transpose([[] | _], acc),
    do: Enum.reverse(acc)

  defp transpose(grid, acc) do
    {tail, row} = Enum.map_reduce(grid, [], fn
      [el | rest], row -> {rest, [el | row]}
    end)

    transpose(tail, [Enum.reverse(row) | acc])
  end

  defp collapse(grid) do
    Stream.map(grid, &collapse(&1, [], []))
  end

  defp collapse([], acc, tail) do
    Enum.reverse(acc)
    |> merge([], tail, 0)
  end

  defp collapse([0 | rest], acc, tail) do
    collapse(rest, acc, [0 | tail])
  end

  defp collapse([el | rest], acc, tail) do
    collapse(rest, [el | acc], tail)
  end

  defp merge([], acc, tail, points),
    do: {acc, tail, points}

  defp merge([el, el | rest], acc, tail, points) do
    sum = el + el

    merge(rest, [sum | acc], [0 | tail], points + sum)
  end

  defp merge([el | rest], acc, tail, points) do
    merge(rest, [el | acc], tail, points)
  end

  defp seed(grid) do
    seed(if(:random.uniform < 0.9, do: 2, else: 4), grid)
  end

  defp seed(num, grid) do
    take_empties(grid)
    |> sample
    |> insert_at(num, grid)
  end

  defp sample({count, empties}) do
    Enum.at(empties, :random.uniform(count) - 1)
  end

  defp insert_at({row_index, index}, num, grid) do
    List.update_at(grid, row_index, &List.replace_at(&1, index, num))
  end

  defp take_empties(grid) do
    Stream.with_index(grid)
    |> Enum.reduce({0, []}, &take_empties/2)
  end

  defp take_empties({row, row_index}, acc) do
    Stream.with_index(row) |> Enum.reduce(acc, fn
      {0, index}, {count, empties} ->
        {count + 1, [{row_index, index} | empties]}

      _cell, acc -> acc
    end)
  end
end
