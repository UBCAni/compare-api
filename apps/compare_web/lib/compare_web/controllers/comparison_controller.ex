defmodule CompareWeb.ComparisonController do
  use CompareWeb, :controller

  action_fallback CompareWeb.FallbackController

  def upload(conn, %{"user" => user, "data" => %{path: path}}) do
    with :ok <- Compare.upload(File.read!(path), user) do
      render(conn, "upload.json", %{})
    end
  end

  def same(conn, %{"user" => user, "other" => other}) do
    with {:ok, result} <- Compare.find_similar(user, other) do
      render(conn, "result.json", result: result)
    end
  end

  def free(conn, %{"user" => user, "other" => other, "weekday" => weekday}) do
    with {:ok, result} <- Compare.find_free(user, other, weekday) do
      render(conn, "free.json", Keyword.new(result))
    end
  end
end
