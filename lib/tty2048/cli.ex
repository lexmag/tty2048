defmodule Tty2048.CLI do
  def main(_args) do
    Tty2048.Game.Watcher.start_link(Tty2048.IO)

    :erlang.hibernate(Kernel, :exit, [:killed])
  end
end

