defmodule CompareWeb.ComparisonView do
  use CompareWeb, :view

  def render("upload.json", %{}) do
    %{status: "success"}
  end

  def render("result.json", %{result: result}) do
    %{"result" => result}
  end

  def render("free.json", %{blocks: blocks, start_time: start_time, end_time: end_time}) do
    %{
      "blocks" => blocks |> Enum.map(fn {s, e} -> "#{visualize(s)} - #{visualize(e)}" end) |> Enum.reverse(),
      "start" => visualize(start_time),
      "end" => visualize(end_time)}
  end

  @spec visualize(Time.t) :: String.t
  defp visualize(date) do
    "#{String.pad_leading("#{date.hour}", 2, "0")}:#{String.pad_leading("#{date.minute}", 2, "0")}"
  end
end
