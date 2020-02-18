defmodule WaitList.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  @roles ~w(kiosk server host manager)

  schema "users" do
    field :role, :string, default: "kiosk"

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, @roles)
  end

  def role_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, @roles)
  end
end
