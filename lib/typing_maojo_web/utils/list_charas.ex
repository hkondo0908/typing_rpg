defmodule TypingMaojoWeb.ListCharas do
  alias TypingMaojoWeb.CsvRead

  def list_up() do
    CsvRead.read_chara()
  end

  def find_chara(id) do
    list_up()
    |> Enum.filter(&(&1["ID"]=="#{id}"))
    |> Enum.at(0)
  end

  def update_chara(id,area,stage,exp) do
    chara = find_chara(id)
    new_chara =
    if stage == "1" do
      %{chara | "到達ステージ" => "1", "経験値" => exp}
    else
      %{chara | "到達エリア" => area,"到達ステージ" => "0" , "経験値" => exp}
    end
    CsvRead.chara_renew(id,new_chara)
  end

end
