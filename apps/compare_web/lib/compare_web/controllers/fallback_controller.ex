defmodule CompareWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CompareWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(CompareWeb.ErrorView, "404.json", [])
  end

  def call(conn, {:error, {user, message}}) when is_bitstring(user) and is_bitstring(message) do
    conn
    |> put_status(:bad_request)
    |> render(CompareWeb.ErrorView, "400.json", user: user, message: message)
  end
end
