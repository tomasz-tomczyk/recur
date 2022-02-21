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

    # Not 100% accurate with iCal RRule until we implement the time
    assert List.last(result).date == ~D[1997-12-24]
  end

  @doc """
    Every other day - forever
    DTSTART;TZID=US-Eastern:19970902T090000
    RRULE:FREQ=DAILY;INTERVAL=2
    ==> (1997 9:00 AM EDT)September2,4,6,8...24,26,28,30;
         October 2,4,6...20,22,24
        (1997 9:00 AM EST)October 26,28,30;November 1,3,5,7...25,27,29;
         Dec 1,3,...
  """
  test "Every other day - forever" do
    result =
      %Event{freq: :daily, date: ~D[1997-09-02], interval: 2}
      |> Recur.get(count: 15)

    assert [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30] ==
             Enum.map(result, & &1.date.day)
  end

  @doc """
    Every 10 days, 5 occurrences
    DTSTART;TZID=US-Eastern:19970902T090000
    RRULE:FREQ=DAILY;INTERVAL=10;COUNT=5
    ==> (1997 9:00 AM EDT)September 2,12,22;October 2,12
  """

  test "Every 10 days, 5 occurences" do
    result =
      %Event{freq: :daily, date: ~D[1997-09-02], interval: 10, count: 5}
      |> Recur.get()

    assert List.last(result).date == ~D[1997-10-12]
  end

  @doc """
    Every day in January, for 3 years:

    DTSTART;TZID=America/New_York:19980101T090000

    RRULE:FREQ=YEARLY;UNTIL=20000131T140000Z;
    BYMONTH=1;BYDAY=SU,MO,TU,WE,TH,FR,SA
    or
    RRULE:FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=1

    ==> (1998 9:00 AM EDT)January 1-31
        (1999 9:00 AM EDT)January 1-31
        (2000 9:00 AM EDT)January 1-31
  """

  test "Every day in January, for 3 years, using by_month, freq daily" do
    result =
      %Event{freq: :daily, date: ~D[1998-01-01], until: ~D[2000-01-31], by_month: 1}
      |> Recur.get()

    years = Enum.map(result, & &1.date.year) |> Enum.uniq()
    months = Enum.map(result, & &1.date.month) |> Enum.uniq()

    assert years == [1998, 1999, 2000]
    assert months == [01]
    assert length(result) == 93

    assert List.last(result).date == ~D[2000-01-31]
  end

  @tag :skip
  test "Every day in January, for 3 years, using by_month, by_day, freq yearly" do
  end
end
