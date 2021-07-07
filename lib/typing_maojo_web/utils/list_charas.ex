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

  def update_chara(id,area,stage) do
    chara = find_chara(id)
    %{"到達エリア"=> r_area,"到達ステージ"=> r_stage} = chara
    new_chara =
    if String.to_integer(area) <= String.to_integer(r_area) do
      chara
    else
      if r_stage == "1" do
        if stage == "1" do
          chara
        else
          %{chara | "到達エリア" => area,"到達ステージ" => "0"}
        end
      else
        if stage == "1" do
          %{chara | "到達ステージ" => "1"}
        else
          %{chara | "到達エリア" => area,"到達ステージ" => "0"}
        end
      end
    end

    CsvRead.chara_renew(id,new_chara)
  end

  def delete_chara(id) do
    chara = find_chara(id)
    new_chara = %{chara | "到達エリア" => "","到達ステージ" => "" , "経験値" => "","名前" => "", "レベル" => ""}
    CsvRead.chara_renew(id,new_chara)
  end

end
