defmodule Compare.Calculator do
  @moduledoc """
  Free time calculator for the application
  """

  @opaque interval :: {Time.t, Time.t}
  @typep accumulator :: {[interval], Time.t}

  @doc """
  Shows what the free blocks are for this schedule

  ## Examples

     iex> a = [{~T[00:00:00], ~T[01:00:00]}, {~T[03:00:00], ~T[04:00:00]}]
     [{~T[00:00:00], ~T[01:00:00]}, {~T[03:00:00], ~T[04:00:00]}]
     iex> b = [{~T[01:00:00], ~T[02:00:00]}]
     [{~T[01:00:00], ~T[02:00:00]}]
     iex> Compare.Calculator.get_free_blocks(a, b)
     [{~T[02:00:00], ~T[03:00:00]}]
  """
  @spec get_free_blocks([interval], [interval]) :: [interval]
  def get_free_blocks([], []), do: [{~T[00:00:00.000], ~T[23:59:59.999]}]
  def get_free_blocks(a, b) do
    union = join(a, b)
    elem(Enum.reduce(union, {[], elem(hd(union), 1)}, &create_free_block/2), 0)
  end


  @spec create_free_block(interval, accumulator) :: accumulator
  defp create_free_block({event_start, event_end}, {result, last}) do
    unless after?(Time.add(last, 3600, :second), event_start) do
      {[{last, event_start} | result], date_max(event_end, last)}
    else
      {result, event_end}
    end
  end

  @spec join([interval], [interval]) :: [interval]
  defp join(a, b) do
    :lists.merge(&(!after?(&1, &2)), a, b)
  end

  @spec after?(interval, interval) :: boolean
  defp after?({time, _}, {other, _}) do
    after?(time, other)
  end

  @spec after?(Time.t, Time.t) :: boolean
  defp after?(a, b) do
    case Time.compare(a, b) do
      :gt -> true
      :lt -> false
      :eq -> false
    end
  end

  @spec date_max(Time.t, Time.t) :: Time.t
  defp date_max(a, b) do
    unless after?(a, b), do: b, else: a
  end
end
