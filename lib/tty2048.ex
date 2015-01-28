defmodule Tty2048 do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children =
      [worker(Tty2048.Game, [4]),
       worker(Tty2048.Game.Watcher, [Tty2048.Driver])]

    Supervisor.start_link(children, strategy: :rest_for_one)
  end
end
