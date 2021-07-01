defmodule TypingMaojo.Repo do
  use Ecto.Repo,
    otp_app: :typing_maojo,
    adapter: Ecto.Adapters.Postgres
end
