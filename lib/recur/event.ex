defmodule Recur.Event do
  @enforce_keys [:freq]
  defstruct [:freq, :date, :until, :interval, :count, :by_month, :by_day]
end
