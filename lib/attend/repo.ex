defmodule Attend.Repo do
  use Ecto.Repo,
    otp_app: :attend,
    adapter: Ecto.Adapters.Postgres
end
