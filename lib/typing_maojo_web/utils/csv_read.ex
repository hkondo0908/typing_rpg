defmodule TypingMaojoWeb.CsvRead do
    def read_CSV do
      Path.expand("sentence.csv")
      |> File.stream!
      |> CSV.Decoding.Decoder.decode(headers: true)
      |> Enum.to_list()
      |> Keyword.get_values(:ok)
    end

    def read_chara do
      Path.expand("characters.csv")
      |> File.stream!
      |> CSV.Decoding.Decoder.decode(headers: true)
      |> Enum.to_list()
      |> Keyword.get_values(:ok)
    end

    def chara_new(id,name) do
      num = String.to_integer(id)
      map = read_chara()
      |> Enum.at(num-1)
      new_map = %{map| "名前" => name, "レベル"=> 1, "経験値"=> 0, "到達ステージ"=> 0,"到達エリア"=> 0}
      new_charas = List.replace_at(read_chara(),num-1,new_map)
      |> CSV.Encoding.Encoder.encode(headers: true)
      |> Enum.to_list()
      Path.expand("characters.csv")
      |> File.write(new_charas)
    end

    def chara_renew(id,chara) do
      num = String.to_integer(id)
      new_charas = List.replace_at(read_chara(),num-1,chara)
      |> CSV.Encoding.Encoder.encode(headers: true)
      |> Enum.to_list()
      Path.expand("characters.csv")
      |> File.write(new_charas)
    end

    def level_new() do
      levels = Enum.map(1..100, fn x->
        %{"レベル"=>x,"経験値"=>x}
      end)
      |> CSV.Encoding.Encoder.encode(headers: true)
      |> Enum.to_list()
      Path.expand("leveling.csv")
      |> File.write(levels)
    end

end
