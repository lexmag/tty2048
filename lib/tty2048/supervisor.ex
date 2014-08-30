defmodule Tty2048.Supervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      # Define workers and child supervisors to be supervised
      # worker(Tty2048.Worker, [arg1, arg2, arg3])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
