defmodule Tty2048.Mixfile do
  use Mix.Project

  def project do
    [app: :tty2048,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: escript()]
  end

  def application do
    [applications: [],
     mod: {Tty2048, []}]
  end

  defp escript do
    [main_module: Tty2048.CLI,
     emu_args: "-noinput -elixir ansi_enabled true"]
  end
end
