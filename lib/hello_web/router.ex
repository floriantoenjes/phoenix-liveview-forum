defmodule HelloWeb.Router do
  use HelloWeb, :router

  alias Hello.Forum

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HelloWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser

#    get "/", PageController, :index
    live "/", BoardsLive
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end

  scope "/boards", HelloWeb do
    pipe_through [:browser, :authenticate_user, :require_existing_author]

    live "/", BoardsLive
    live "/:id", BoardDetailLive

    live "/:id/threads/:thread_id", ThreadDetailLive


    resources "/", BoardController do
      resources "/threads", ThreadController do
        resources "/posts", PostController
      end
    end
  end

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
      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
    end
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/sessions/new")
        |> halt()
      user_id ->
        assign(conn, :current_user, Hello.Accounts.get_user!(user_id))
    end
  end

  defp require_existing_author(conn, _) do
    author = Forum.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end
end
