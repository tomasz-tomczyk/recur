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

  @doc """
    Daily until December 24, 1997
    DTSTART;TZID=US-Eastern:19970902T090000
    RRULE:FREQ=DAILY;UNTIL=19971224T000000Z
    ==> (1997 9:00 AM EDT)September 2-30;October 1-25
        (1997 9:00 AM EST)October 26-31;November 1-30;December 1-23
  """
  test "Daily until December 24, 1997" do
    result =
      %Event{freq: :daily, date: ~D[1997-09-02], until: ~D[1997-12-24]}
      |> Recur.get()

    assert List.last(result).date == ~D[1997-12-23]
  end
end
