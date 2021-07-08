defmodule TypingMaojoWeb.Information do
  alias TypingMaojoWeb.CsvRead
  def list_up do
    CsvRead.read_info()
  end

  def find_info(id) do
    list_up()
    |> Enum.filter(&(&1["id"] == id))
    |> Enum.at(0)
  end

  def renew(id,info) do
    num = String.to_integer(id) - 1
    list_up()
    |> List.replace_at(num,info)
  end
end
