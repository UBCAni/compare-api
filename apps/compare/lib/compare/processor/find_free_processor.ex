defmodule Compare.Processor.FindFreeProcessor do
  @behaviour Compare.Processor

  @moduledoc """
  For calculating free blocks within a schedule
  """

  def process(user, other, opts \\ []) do
    weekday = Keyword.get(opts, :weekday)
    user_blocks = ops(user, weekday)
    other_blocks = ops(other, weekday)

    {:ok, Compare.Calculator.get_free_blocks(user_blocks, other_blocks)}
  end

  defp ops(data, weekday) do
    data |> Enum.filter(&on_weekday?(&1, weekday)) |> Enum.map(&extract_interval/1) |> Enum.into([])
  end

  @spec extract_interval(ExIcal.Event) :: {Time.t, Time.t}
  defp extract_interval(%{start: event_start, end: event_end}) do
    {Time.new(event_start.hour, event_start.minute, 0) |> elem(1), Time.new(event_end.hour, event_end.minute, 0) |> elem(1)}
  end

  @spec on_weekday?(ExIcal.Event, 1..5) :: boolean
  defp on_weekday?(%{start: %{year: year, month: month, day: day}}, weekday) do
    Date.day_of_week(Date.new(year, month, day) |> elem(1)) == weekday
  end
end
