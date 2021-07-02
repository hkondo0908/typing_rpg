defmodule TypingMaojoWeb.MakeList do
    def list_up do
        ["pow","test","I was born to love you.", "Thank you!", "wonderful", "ape"]
    end
    
    def ex_sentence(number) do
        list = ["pow","test","I was born to love you.", "Thank you!", "wonderful", "ape"]
        Enum.at(list, number)
    end
end