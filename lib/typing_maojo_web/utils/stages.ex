defmodule TypingMaojoWeb.Stages do
  alias TypingMaojoWeb.CsvRead
  def list_up() do
    CsvRead.read_stages()
  end

  def find_exp(area,stage) do
    stage_map = list_up()
    |> Enum.filter(&
      (&1["Area"] == area and &1["Stage"] == stage)
    )
    |> Enum.at(0)
    String.to_integer(stage_map["Exp"])
  end
end
