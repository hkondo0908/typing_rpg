defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.ListCharas
    alias TypingMaojoWeb.MakeList
    alias TypingMaojoWeb.Levels
    alias TypingMaojoWeb.Stages
    def mount(%{"id"=>id,"area"=>area,"stage"=>stage},_session,socket) do
        {:ok,first_socket(id,area,stage,socket)}
    end

    defp ex_functions(area, stage, count) do
        MakeList.list_up_result(area, stage)
        |> Enum.take(count)
        |> Enum.map(&Enum.slice(&1, 2, 3))
    end

    defp first_socket(id,area,stage,socket) do
        time = socket.assigns.flash["time"]
        error = socket.assigns.flash["error"]
        misstypes = socket.assigns.flash["misstypes"]
        result = socket.assigns.flash["result"]
        count = socket.assigns.flash["count"]
        context =
        case result do
            :completed -> "クリア!!\n#{time}秒"
            :finished -> if count < 10 do
                "失敗...\n時間切れ!"
            else
                "成功!!"
            end
            :failed -> "失敗...\nHP切れ..."
            _ -> "Finished!"
        end
        if result == :completed do
            ListCharas.update_chara(id,area,stage)
        end
        functions = ex_functions(area, stage, count)

        exp = (Stages.find_exp(area,stage)) * count
        Levels.level_up(id,to_string(exp))
        %{"経験値" => exp_now, "レベル" => level_now} = ListCharas.find_chara(id)

        assign(socket,[
            context: context,
            result: result,
            error: error,
            count: count,
            misstypes: misstypes,
            area: area,
            stage: stage,
            functions: functions,
            id: id,
            get_exp: to_string(exp),
            exp: exp_now,
            level: level_now
        ])
    end
end
