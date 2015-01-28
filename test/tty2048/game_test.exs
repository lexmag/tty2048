defmodule Tty2048.GameTest do
  use ExUnit.Case

  alias Tty2048.Game

  defmodule Watcher do
    use GenEvent

    def start_link(test) do
      Game.Watcher.start_link(__MODULE__, test)
    end

    def init({_game, test}),
      do: {:ok, test}

    def handle_event(%Game{} = game, test) do
      send(test, game)
      {:ok, test}
    end
  end

  defp watch_game(game) do
    {:ok, _} = Game.start_link(%{game | score: 1})
    {:ok, _} = Watcher.start_link(self)
  end

  test "move left" do
    watch_game(%Game{grid: [[2, 2]]})

    Game.move(:left)

    assert_receive %Game{grid: [[4, _]], score: 5}
  end

  test "move right" do
    watch_game(%Game{grid: [[2, 2]]})

    Game.move(:right)

    assert_receive %Game{grid: [[_, 4]], score: 5}
  end

  test "move up" do
    watch_game(%Game{grid: [[2], [2]]})

    Game.move(:up)

    assert_receive %Game{grid: [[4], [_]], score: 5}
  end

  test "move down" do
    watch_game(%Game{grid: [[2], [2]]})

    Game.move(:down)

    assert_receive %Game{grid: [[_], [4]], score: 5}
  end
end
