defmodule Recur.Event do
  @enforce_keys [:freq]
  defstruct [:freq, :date, :until, :interval, :count]
end
