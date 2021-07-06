defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.MakeList

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
        functions = ex_functions(area, stage, socket.assigns.flash["count"])
        {:ok,assign(socket,[result: result, error: error, misstypes: misstypes, area: area, stage: stage, functions: functions])}
    end

    defp ex_functions(area, stage, count) do
        MakeList.list_up_result(area, stage)
        |> Enum.take(count)
        |> Enum.map(&Enum.slice(&1, 2, 3))
    end
end
