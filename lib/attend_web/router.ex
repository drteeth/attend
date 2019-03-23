defmodule AttendWeb.Router do
  use AttendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AttendWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/teams", TeamController, only: [:index, :show, :new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AttendWeb do
  #   pipe_through :api
  # end
end
