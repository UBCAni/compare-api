defmodule Compare.Processor do
  @moduledoc """
  Provides a behaviour for different data processors
  """
  alias Compare.Storage
  require Logger

  @callback process([%ExIcal.Event{}], [%ExIcal.Event{}], keyword) :: any

  @doc """
  Compare dynamically dispatches code to a processor, handling the common execution paths.
  """
  @spec compare(module, String.t, String.t) :: {:ok, %{any => any}}
  def compare(processor, user, other, opts \\ []) do
    Logger.info("Comparing schedules between users '#{user}' and '#{other}'")

    cond do
      !Storage.exists?(user) -> {:error, {user, "has not uploaded their schedule"}}
      !Storage.exists?(other) -> {:error, {other, "has not uploaded their schedule"}}

      true ->
        with {:ok, user} <- Storage.read(user),
             {:ok, other} <- Storage.read(other) do
          user = Enum.filter(:erlang.binary_to_term(user), &filter_by_semester/1)
          other = Enum.filter(:erlang.binary_to_term(other), &filter_by_semester/1)

          Logger.info("Schedule successfully received")
          Logger.info("Valid classes for user: #{length(user)}")
          Logger.info("Valid classes for other: #{length(other)}")

          processor.process(user, other, opts)
        end
    end
  end

  @spec filter_by_semester(ExIcal.Event) :: boolean
  defp filter_by_semester(%{start: %{year: y}}) do
    y == 2018
  end
end
