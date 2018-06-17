defmodule Compare.Processor do
  @moduledoc """
  Provides a behaviour for different data processors
  """
  alias Compare.Storage

  @callback process([%ExIcal.Event{}], [%ExIcal.Event{}], keyword) :: any

  @doc """
  Compare dynamically dispatches code to a processor, handling the common execution paths.
  """
  @spec compare(module, String.t, String.t) :: {:ok, %{any => any}}
  def compare(processor, user, other, opts \\ []) do
    cond do
      !Storage.exists?(user) -> {:error, {user, "has not uploaded their schedule"}}
      !Storage.exists?(other) -> {:error, {other, "has not uploaded their schedule"}}

      true ->
        with {:ok, user} <- Storage.read(user),
             {:ok, other} <- Storage.read(other) do
          user = Enum.filter(:erlang.binary_to_term(user), &filter_by_semester/1)
          other = Enum.filter(:erlang.binary_to_term(other), &filter_by_semester/1)

          processor.process(user, other, opts)
        end
    end
  end

  @spec filter_by_semester(ExIcal.Event) :: boolean
  defp filter_by_semester(event) do
    event.start.year == 2018
  end
end
