defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.ListCharas
    def mount(%{"id"=>id,"area"=>area,"stage"=>stage},_session,socket) do
        time = socket.assigns.flash["time"]
        error = socket.assigns.flash["error"]
        misstypes = socket.assigns.flash["misstypes"]
        result = socket.assigns.flash["result"]
        context =
        case result do
            :completed -> "Congratulations!!\n#{time}秒"
            :finished -> if socket.assigns.flash["count"] < 10 do
                "Failed...\nTime is Over!"
            else
                "Congratulations!!"
            end
            :failed -> "Failed...\nYou are lost..."
            _ -> "Finished!"
        end
        if result == :completed do
            ListCharas.update_chara(id,area,stage,"30")
        end
        {:ok,assign(socket,[context: context, result: result, error: error, misstypes: misstypes,area: area,stage: stage, id: id])}
    end
end
