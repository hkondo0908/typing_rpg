defmodule TypingMaojoWeb.LayoutView do
  use TypingMaojoWeb, :view
  alias TypingMaojoWeb.CsvRead

  def get_name(id) do
    chara_data =
    CsvRead.read_chara
    |> Enum.filter(fn x -> x["ID"] == id end)
    |> List.first
    chara_data["名前"]
  end

  def get_level(id) do
    chara_data =
    CsvRead.read_chara
    |> Enum.filter(fn x -> x["ID"] == id end)
    |> List.first
    chara_data["レベル"]
  end
end
