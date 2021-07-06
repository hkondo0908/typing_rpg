defmodule TypingMaojoWeb.MakeList do
    alias TypingMaojoWeb.CsvRead
    def list_up(area,stage) do
        CsvRead.read_CSV
        |> Enum.map(&[&1["Area"],&1["Stage"],&1["Sentence"]])
        |> Enum.filter(fn [a,s,_t] ->
            a==area and s == stage
        end)

    end

    def ex_sentence(area,stage,number) do
        list_up(area,stage)
        |> Enum.at(number)
        |> Enum.at(2)
    end

    def sentence_length(area,stage,number) do
        String.length(ex_sentence(area,stage,number)) - 1
    end

    def list_length(area,stage) do
        list_up(area,stage)
        |>length()
    end

    def list_up_result(area,stage) do
        CsvRead.read_CSV
        |> Enum.map(&[&1["Area"],&1["Stage"],&1["Sentence"],&1["Return"]])
        |> Enum.filter(fn [a,s,_t,_r] ->
            a==area and s == stage
        end)
    end


end
