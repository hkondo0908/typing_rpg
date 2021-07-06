defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    def mount(_params,_session,socket) do
        area = socket.assigns.flash["area"]
        stage = socket.assigns.flash["stage"]
        time = socket.assigns.flash["time"]
        error = socket.assigns.flash["error"]
        misstypes = socket.assigns.flash["misstypes"]
        result =
        case socket.assigns.flash["result"] do
            :completed -> "Congratulations!!\n#{time}秒"
            :finished -> if socket.assigns.flash["count"] < 10 do
                "Failed...\nTime is Over!"
            else
                "Congratulations!!"
            end
            :failed -> "Failed...\nYou are lost..."
            _ -> "Finished!"
        end
        {:ok,assign(socket,[result: result, error: error, misstypes: misstypes,area: area,stage: stage])}
    end
end
