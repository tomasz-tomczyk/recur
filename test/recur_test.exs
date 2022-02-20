defmodule RecurTest do
  use ExUnit.Case, async: true
  doctest Recur

  test "stream/1" do
    stream = Recur.stream(%Recur.Event{freq: :daily, date: ~D[2022-01-01]})

    assert [
             %{date: ~D[2022-01-01]},
             %{date: ~D[2022-01-02]}
           ] = stream |> Enum.take(2)
  end
end
