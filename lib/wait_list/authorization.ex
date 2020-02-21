defmodule WaitList.Authorization do
  alias __MODULE__
  alias WaitList.Parties.Party
  alias WaitList.Users.User
  defstruct role: nil, create: %{}, read: %{}, update: %{}, delete: %{}

  def can("kiosk" = role) do
    grant(role)
    |> create(Party)
    |> read(Party)
  end

  def can("server" = role) do
    grant(role)
    |> read(Party)
  end

  def can("host" = role) do
    grant(role)
    |> all(Party)
  end

  def can("manager" = role) do
    grant(role)
    |> all(Party)
    |> all(User)
  end

  def grant(role), do: %Authorization{role: role}

  def read(authorization, resource), do: put_action(authorization, :read, resource)

  def create(authorization, resource), do: put_action(authorization, :create, resource)

  def update(authorization, resource), do: put_action(authorization, :update, resource)

  def delete(authorization, resource), do: put_action(authorization, :delete, resource)

  def all(authorization, resource) do
    authorization
    |> create(resource)
    |> read(resource)
    |> update(resource)
    |> delete(resource)
  end

  def read?(authorization, resource) do
    Map.get(authorization.read, resource, false)
  end

  def create?(authorization, resource) do
    Map.get(authorization.create, resource, false)
  end

  def update?(authorization, resource) do
    Map.get(authorization.update, resource, false)
  end

  def delete?(authorization, resource) do
    Map.get(authorization.delete, resource, false)
  end

  defp put_action(authorization, action, resource) do
    updated_action =
      authorization
      |> Map.get(action)
      |> Map.put(resource, true)

    Map.put(authorization, action, updated_action)
  end
end
