defmodule WaitListWeb.PageController do
  use WaitListWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
