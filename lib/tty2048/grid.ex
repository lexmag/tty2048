defmodule Tty2048.Grid do
  def make(size) when size > 0 do
    seed(for _ <- 1..size, do: make_row(size))
  end

  defdelegate format(grid), to: __MODULE__.Formatter

  def move({direction, grid}) do
    move(grid, direction)
    |> seed
  end

  defp move(grid, :left) do
    for {acc, tail} <- collapse(grid) do
      Enum.reverse(acc, tail)
    end
  end

  defp move(grid, :right) do
    Enum.map(grid, &Enum.reverse/1) |> collapse |> Enum.map fn
      {acc, tail} -> tail ++ acc
    end
  end

  defp move(grid, :up) do
    transpose(grid)
    |> move(:left)
    |> transpose
  end

  defp move(grid, :down) do
    transpose(grid)
    |> move(:right)
    |> transpose
  end

  defp make_row(size) do
    for _ <- 1..size, do: 0
  end

  defp transpose(grid, acc \\ [])

  defp transpose([[]|_], acc) do
    Enum.reverse(acc)
  end

  defp transpose(grid, acc) do
    {tail, row} = Enum.map_reduce(grid, [], fn
      [el|rest], row -> {rest, [el|row]}
    end)

    transpose(tail, [Enum.reverse(row)|acc])
  end

  defp collapse(grid) do
    Stream.map(grid, &collapse(&1, [], []))
  end

  defp collapse([], acc, tail) do
    Enum.reverse(acc) |> merge([], tail)
  end

  defp collapse([0|rest], acc, tail) do
    collapse(rest, acc, [0|tail])
  end

  defp collapse([el|rest], acc, tail) do
    collapse(rest, [el|acc], tail)
  end

  defp merge([], acc, tail), do: {acc, tail}

  defp merge([el, el|rest], acc, tail) do
    merge(rest, [el + el|acc], [0|tail])
  end

  defp merge([el|rest], acc, tail) do
    merge(rest, [el|acc], tail)
  end

  defp seed(grid), do: seed(2, grid)

  defp seed(num, grid) do
    take_empties(grid)
    |> sample
    |> insert_at(num, grid)
  end

  defp sample({count, empties}) do
    Enum.at(empties, :random.uniform(count) - 1)
  end

  defp insert_at({row_index, index}, num, grid) do
    Stream.with_index(grid) |> Enum.map fn
      {row, i} when i == row_index ->
        insert_at(index, num, row)

      {row, _i} -> row
    end
  end

  defp insert_at(index, num, row) do
    Stream.with_index(row) |> Enum.map fn
      {_cell, i} when i == index -> num

      {cell, _i} -> cell
    end
  end

  defp take_empties(grid) do
    Stream.with_index(grid)
    |> Enum.reduce({0, []}, &take_empties/2)
  end

  defp take_empties({row, row_index}, acc) do
    Stream.with_index(row) |> Enum.reduce acc, fn
      {0, index}, {count, empties} ->
        {count + 1, [{row_index, index} | empties]}

      _cell, acc -> acc
    end
  end
end
