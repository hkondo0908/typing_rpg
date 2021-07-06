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
        functions = ex_functions(area, stage, socket.assigns.flash["count"])
        {:ok,assign(socket,[context: context,result: result, error: error, misstypes: misstypes, area: area, stage: stage, functions: functions, id: id])}
    end

    defp ex_functions(area, stage, count) do
        MakeList.list_up_result(area, stage)
        |> Enum.take(count)
        |> Enum.map(&Enum.slice(&1, 2, 3))
    end
end
