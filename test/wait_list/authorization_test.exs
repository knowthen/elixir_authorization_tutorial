defmodule WaitList.AuthorizationTest do
  use ExUnit.Case
  import WaitList.Authorization, except: [can: 1]
  alias WaitList.Parties.Party
  
  def can("kiosk" = role) do
    grant(role)
    |> read(Party)
    |> create(Party)
  end
  
  test "role can read resource" do
    assert can("kiosk") |> read?(Party)
  end
  
  test "role can create resource" do
    assert can("kiosk") |> create?(Party)
  end

  test "role can not update resource" do
    refute can("kiosk") |> update?(Party)
  end
  
  test "role can not delete resource" do
    refute can("kiosk") |> delete?(Party)
  end
end