defmodule CompareWeb.ComparisonController do
  use CompareWeb, :controller

  action_fallback CompareWeb.FallbackController

  def upload(conn, %{"user" => user, "data" => %{path: path}}) do
    with :ok <- Compare.upload(File.read!(path), user) do
      render(conn, "upload.json", %{})
    end
  end

  def compare(conn, %{"user" => user, "other" => other}) do
    with %{same: same} <- Compare.compare(user, other) do
      render(conn, "compare.json", same: same)
    end
  end
end
