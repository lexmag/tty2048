defmodule Tty2048 do
  use Application

  def start(_type, _args) do
    Tty2048.Supervisor.start_link
  end
end
