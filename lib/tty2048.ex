defmodule Tty2048 do
  use Application

  def start(_type, _args) do
    {:ok, _} = Tty2048.Random.start_link
    Tty2048.Supervisor.start_link
  end
end
