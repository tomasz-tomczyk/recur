defmodule Recur do
  @moduledoc """
  Entry point for `Recur`
  """

  @doc """
  Given an event, returns its occurances

  ## Examples

      iex> Recur.get(%Recur.Event{freq: :daily, date: ~D[2022-01-01]}, count: 1)
      [%Recur.Event{freq: :daily, date: ~D[2022-01-01]}]
  """

  def get(%Recur.Event{} = event, options \\ [count: :all]) do
    result = Recur.stream(event)

    case Keyword.get(options, :count) do
      :all -> result |> Enum.to_list()
      count -> result |> Enum.take(count)
    end
  end

  @doc """
  Given an event, returns its next occurance

  ## Examples

      iex> Recur.stream(%Recur.Event{freq: :daily, date: ~D[2022-01-01]})
      ...> |> Enum.take(2)
      [%Recur.Event{freq: :daily, date: ~D[2022-01-01]}, %Recur.Event{freq: :daily, date: ~D[2022-01-02]}]
  """
  def stream(%Recur.Event{} = event) do
    Stream.unfold(event, fn event ->
      cond do
        event.until && Date.compare(event.date, event.until) in [:eq, :gt] -> nil
        event.count == 0 -> nil
        true -> {event, next_occurance(event)}
      end
    end)
  end

  @doc """
  Given an event, returns its next occurance

  ## Examples

      iex> Recur.next_occurance(%Recur.Event{freq: :daily, date: ~D[2022-01-01]})
      %Recur.Event{freq: :daily, date: ~D[2022-01-02]}
  """
  def next_occurance(%Recur.Event{freq: :daily} = event) do
    number_of_days = 1

    count =
      case event.count do
        nil -> nil
        count -> count - 1
      end

    event
    |> Map.put(:date, Date.add(event.date, number_of_days))
    |> Map.put(:count, count)
  end
end
