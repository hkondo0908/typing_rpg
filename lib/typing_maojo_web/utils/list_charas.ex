defmodule TypingMaojoWeb.ListCharas do
  alias TypingMaojoWeb.CsvRead

  def list_up() do
    CsvRead.read_chara()
  end

  def find_chara(id) do
    list_up()
    |> Enum.filter(&(&1["id"]==id))
    |> Enum.at(0)
  end

end
