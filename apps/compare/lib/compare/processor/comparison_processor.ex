defmodule Compare.Processor.SimilarityProcessor do
  @behaviour Compare.Processor

  @moduledoc """
  For calcululating the similarity between modules
  """

  def process(user, other, _) do
    user_classes = Enum.map(user, &extract_summary/1) |> Enum.into(MapSet.new)
    other_classes = Enum.map(other, &extract_summary/1) |> Enum.into(MapSet.new)

    {:ok, MapSet.intersection(user_classes, other_classes)}
  end

  @spec extract_summary(ExIcal.Event) :: String.t
  defp extract_summary(%{summary: summary}) do
    [department, class, _] = String.split(summary)
    "#{department} #{class}"
  end
end
