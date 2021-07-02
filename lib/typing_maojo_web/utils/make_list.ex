defmodule TypingMaojoWeb.MakeList do
    alias TypingMaojoWeb.CsvRead
    def list_up do
        CsvRead.read_CSV
        |> Enum.map(&(&1["Sentence"]))
    end
    
    def ex_sentence(number) do
        list_up
        |> Enum.at(number)
    end
end