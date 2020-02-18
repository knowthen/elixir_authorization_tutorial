import EctoEnum
defenum(PartyStatusEnum, waiting: 0, seated: 1, cancelled: 2)

defmodule WaitList.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parties" do
    field :name, :string
    field :size, :integer
    field :status, PartyStatusEnum, default: 0

    timestamps()
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:name, :size, :status])
    |> validate_required([:name, :size])
  end
end
