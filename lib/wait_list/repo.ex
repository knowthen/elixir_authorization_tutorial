defmodule WaitList.Repo do
  use Ecto.Repo,
    otp_app: :wait_list,
    adapter: Ecto.Adapters.Postgres
end
