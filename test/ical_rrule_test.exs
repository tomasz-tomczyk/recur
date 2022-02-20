defmodule ICalRRuleTest do
  use ExUnit.Case, async: true
  alias Recur.Event

  @doc """
    Daily for 10 occurrences
    DTSTART;TZID=US-Eastern:19970902T090000
    RRULE:FREQ=DAILY;COUNT=10
    ==> (1997 9:00 AM EDT)September 2-11
  """
  test "Daily for 10 occurrences" do
    result =
      %Event{freq: :daily, date: ~D[1997-09-02], count: 10}
      |> Recur.get()

    assert List.last(result).date == ~D[1997-09-11]
  end
end
