defmodule Tty2048.Grid.FormatterTest do
  use ExUnit.Case

  import Tty2048.Grid.Formatter

  cases = %{
    0    => "\e[2m\e[37m   *\e[0m\n\e[0m",
    2    => "\e[32m   2\n\e[0m",
    4    => "\e[33m   4\n\e[0m",
    8    => "\e[36m   8\n\e[0m",
    16   => "\e[34m  16\n\e[0m",
    32   => "\e[31m  32\n\e[0m",
    64   => "\e[35m  64\n\e[0m",
    128  => "\e[33m 128\n\e[0m",
    256  => "\e[36m 256\n\e[0m",
    512  => "\e[34m 512\n\e[0m",
    1024 => "\e[35m  1k\n\e[0m",
    2048 => "\e[31m  2k\n\e[0m",
    1    => "\e[37m   1\n\e[0m",
    720  => "\e[37m 720\n\e[0m",
    2500 => "\e[37m  2k\n\e[0m",
    4096 => "\e[37m  4k\n\e[0m"
  }

  for {cell, output} <- cases do
    test "format #{cell}" do
      assert IO.iodata_to_binary(format([[unquote(cell)]])) == unquote(output)
    end
  end
end
