defmodule CompareWeb.ComparisonView do
  use CompareWeb, :view

  def render("upload.json", %{}) do
    %{status: "success"}
  end

  def render("result.json", %{result: result}) do
    %{"result" => result}
  end

  def render("free.json", %{blocks: blocks, start_time: start_time, end_time: end_time}) do
    %{"blocks" => blocks |> Enum.map(fn {s, e} -> "#{s} - #{e}" end) |> Enum.reverse(), "start" => start_time, "end" => end_time}
  end
end
