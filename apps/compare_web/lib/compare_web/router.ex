defmodule CompareWeb.Router do
  use CompareWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CompareWeb do
    pipe_through :api
  end
end
