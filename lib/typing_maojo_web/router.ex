defmodule TypingMaojoWeb.Router do
  use TypingMaojoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TypingMaojoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TypingMaojoWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/game/start", StartLive
    live "/game/main/:area/:stage", MainLive
    live "/game/finish", FinishLive
    live "/game/stage/:area", AreaLive
    live "/game/area", WorldLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TypingMaojoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TypingMaojoWeb.Telemetry
    end
  end
end
