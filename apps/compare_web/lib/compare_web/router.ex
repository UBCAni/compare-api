defmodule CompareWeb.Router do
  use CompareWeb, :router

  pipeline :api do
    plug :accepts, ["json", "multipart"]
  end

  scope "/api", CompareWeb do
    pipe_through :api

    post "/upload", ComparisonController, :upload
    post "/compare", ComparisonController, :compare
  end
end
