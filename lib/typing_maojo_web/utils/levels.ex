defmodule TypingMaojoWeb.Levels do
  alias TypingMaojoWeb.CsvRead
  alias TypingMaojoWeb.ListCharas

  def list_up() do
    CsvRead.read_level()
  end

  def level_up(id,exp) do
    exp = String.to_integer(exp)
    chara = ListCharas.find_chara(id)
    %{"レベル" => level_now, "経験値" => exp_now } = chara
    exp_now = String.to_integer(exp_now)
    level_now = String.to_integer(level_now)
    {new_level,new_exp} = find_level(exp,exp_now,level_now)
    new_chara = %{chara | "レベル" => to_string(new_level), "経験値" => to_string(new_exp)}
    CsvRead.chara_renew(id,new_chara)
  end

  def find_level(exp,exp_now,level_now) do
    map = list_up()
    |> Enum.filter(
      &(String.to_integer(&1["レベル"]) == level_now)
    )
    |> Enum.at(0)
    required_exp = String.to_integer(map["経験値"])
    {level,exp} =
    if required_exp > exp + exp_now do
      {level_now, exp + exp_now}
    else
      find_level(exp + exp_now - required_exp,0,level_now + 1)
    end
    {level,exp}
  end

end
