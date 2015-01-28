defmodule Tty2048.Game.Watcher do
  use GenServer

  def start_link(handler, args \\ []) do
    GenServer.start_link(__MODULE__, {handler, args})
  end

  def init({handler, args}) do
    {manager, game} = Tty2048.Game.peek
    :ok = GenEvent.add_mon_handler(manager, handler, {game, args})
    {:ok, {handler, Process.monitor(manager)}}
  end

  def handle_info({:gen_event_EXIT, handler, reason}, {handler, _} = state) do
    {:stop, reason, state}
  end

  def handle_info({:DOWN, ref, _, _, reason}, {_, ref} = state) do
    {:stop, reason, state}
  end
end
