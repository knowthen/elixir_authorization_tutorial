defmodule WaitListWeb.Router do
  use WaitListWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", WaitListWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", WaitListWeb do
    pipe_through [:browser, :protected]
    resources "/users", UserController, only: [:index, :edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", WaitListWeb do
  #   pipe_through :api
  # end
end
