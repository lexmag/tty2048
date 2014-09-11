defmodule Tty2048.Mixfile do
  use Mix.Project

  def project do
    [app: :tty2048,
     version: "0.0.1",
     elixir: "~> 1.0.0"]
  end

  def application do
    [applications: [],
     mod: {Tty2048, []}]
  end
end
