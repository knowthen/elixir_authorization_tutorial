defmodule WaitListWeb.PutSessionUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns.current_user
    put_session(conn, "current_user", current_user)
  end
end
