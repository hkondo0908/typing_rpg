defmodule TypingMaojoWeb.MakeList do
    alias TypingMaojoWeb.CsvRead
    def list_up do
        CsvRead.read_CSV
        |> Enum.map(&(&1["Sentence"]))
    end

    def ex_sentence(number) do
        list_up()
        |> Enum.at(number)
    end

    def sentence_length(number) do
        String.length(ex_sentence(number)) - 1
    end

    def list_length() do
        list_up()
        |>length()
    end
end
