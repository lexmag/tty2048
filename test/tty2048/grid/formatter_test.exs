defmodule Tty2048.Grid.FormatterTest do
  use ExUnit.Case

  import Tty2048.Grid.Formatter

  cases = %{
    [[0]]      => "\e[2m\e[37m   *\e[0m",
    [[2]]      => "\e[32m   2",
    [[4]]      => "\e[33m   4",
    [[8]]      => "\e[36m   8",
    [[16]]     => "\e[34m  16",
    [[32]]     => "\e[31m  32",
    [[64]]     => "\e[35m  64",
    [[128]]    => "\e[33m 128",
    [[256]]    => "\e[36m 256",
    [[512]]    => "\e[34m 512",
    [[1024]]   => "\e[35m  1k",
    [[2048]]   => "\e[31m  2k",
    [[720]]    => "\e[37m 720",
    [[2500]]   => "\e[37m  2k",
    [[4096]]   => "\e[37m  4k",
    [[1], [1]] => "\e[37m   1\r\n\e[37m   1"
  }

  for {grid, output} <- cases do
    test "format #{inspect grid}" do
      assert IO.iodata_to_binary(format(unquote(grid))) == <<"\e[H\e[2J", unquote(output), "\r\n\e[0m">>
    end
  end
end
