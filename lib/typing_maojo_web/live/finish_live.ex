defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    def mount(_params,_session,socket) do

        time = socket.assigns.flash["time"]
        error = socket.assigns.flash["error"]
        result = 
        case socket.assigns.flash["result"] do
            :completed -> "Conglatulations!!\nClear Time: #{time}"
            :finished -> if socket.assigns.flash["count"] < 9 do
                "Failed...\nTime is Over!"
            else
                "Conglatulations!!"
            end
            :failed -> "Failed...\nYou are lost..."
            _ -> "Finished!"
        end
        IO.inspect(error)
        {:ok,assign(socket,[result: result, error: error])}
    end
end