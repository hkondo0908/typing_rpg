defmodule TypingMaojoWeb.CsvRead do
    def read_CSV do
        Path.expand("sentence.csv")
        |> File.stream!
        |> CSV.Decoding.Decoder.decode(headers: true)
        |> Enum.to_list()
        |> Keyword.get_values(:ok)
      end
end