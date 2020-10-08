defmodule WaitListWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  import WaitList.Authorization
  alias WaitListWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, opts) do
    role = conn.assigns.current_user.role
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)

    check(action, role, resource)
    |> maybe_continue(conn)
  end

  defp maybe_continue(true, conn), do: conn

  defp maybe_continue(false, conn) do
    conn
    |> put_flash(:error, "You're not authorized to do that!")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  # Old Code
  # defp check(:index, role, resource) do
  #   can(role) |> read?(resource)
  # end

  """
  Hi Mr.Moore
  There is have a bug!!!
  When i use `mix phx.gen.html <Any> ` generate html/controller/view and schema.

  In the `Old Code` ,if i click the `Save` button, that will have two flashes and redirect to the index page :
    - "Article created successfully"
    - "You're not authorized to do that!"

  Because the action of `show` is missing
  """

  # New Code
  defp check(action, role, resource) when action in [:show, :index] do
    can(role) |> read?(resource)
  end

  #

  defp check(action, role, resource) when action in [:new, :create] do
    can(role) |> create?(resource)
  end

  defp check(action, role, resource) when action in [:edit, :update] do
    can(role) |> update?(resource)
  end

  defp check(:delete, role, resource) do
    can(role) |> delete?(resource)
  end

  defp check(_action, _role, _resource), do: false
end
