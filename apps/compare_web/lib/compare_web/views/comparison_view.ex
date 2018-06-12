defmodule CompareWeb.ComparisonView do
  use CompareWeb, :view

  def render("upload.json", %{}) do
    %{status: "success"}
  end

  def render("compare.json", %{same: same}) do
    %{"same" => same}
  end
end
