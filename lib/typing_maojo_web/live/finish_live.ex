defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    def mount(_params,_session,socket) do
        result = 
        case socket.assigns.flash["result"] do
            :complete -> "Conglatulations!!"
            :finished -> if socket.assigns.flash["count"] < 9 do
                "Failed...\nTime is Over!"
            else
                "Conglatulations!!"
            end
            :failed -> "Failed...\nYou are lost..."
            _ -> "Finished!"
        end
        {:ok,assign(socket,result: result)}
    end
end