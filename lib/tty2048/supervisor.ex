defmodule Tty2048.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(nil) do
    children = [
      worker(Tty2048.Game, [Tty2048.Game.new(4)]),
      worker(Tty2048.Driver, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
