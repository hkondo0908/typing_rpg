defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.ListCharas
    alias TypingMaojoWeb.MakeList
    alias TypingMaojoWeb.CsvRead
    alias TypingMaojoWeb.Information

    def mount(%{"id"=>id,"area"=>area,"stage"=>stage},_session,socket) do
        {:ok,first_socket(id,area,stage,socket)}
    end

    defp ex_functions(area, stage, sentence_list) do
        list = MakeList.list_up_result(area, stage)
        Enum.map(sentence_list,fn x->
           result = Enum.map(list, fn y ->
            [Enum.at(y,2),Enum.at(y,3)]
           end)
            index = Enum.find_index(result,fn w->
                Enum.at(w,0)==x
            end)
            Enum.at(result,index)

        end)
    end

    defp first_socket(id,area,stage,socket) do
        time = socket.assigns.flash["time"]
        error = socket.assigns.flash["error"]
        misstypes = socket.assigns.flash["misstypes"]
        result = socket.assigns.flash["result"]
        count = socket.assigns.flash["count"]
        exp = socket.assigns.flash["exp"]
        level_now = socket.assigns.flash["level_now"]
        sentence_list = socket.assigns.flash["sentence_list"]
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

        functions = ex_functions(area, stage, sentence_list)

        %{"経験値" => exp_now, "レベル" => level_new} = ListCharas.find_chara(id)
        levelupflag=
        if level_new != level_now do
            true
        else
            false
        end

        list = socket.assigns.flash["sentence_list"]
        IO.inspect(list)
        sent_list = MakeList.list_up_straight(area,stage)
        pre_info = Information.find_info(id)
        sent = "#{exp}^#{error}^#{count}^#{time}^"
        now = (String.to_integer(area) - 1) * 2 + String.to_integer(stage)
        to = "m#{now}"
        str = pre_info[to]
        [sent,f1,f2,f3,f4] =
        if !str or str == "" do
            [sent,1,1,1,1]
        else
            [pre_exp,pre_error,pre_count,pre_time | _] = String.split(str,"^")
            [new_exp,b1] =
            if exp > String.to_integer(pre_exp) do
                [exp,1]
            else
                [pre_exp,0]
            end
            [new_error,b2] =
            if error > String.to_integer(pre_error) or result != :completed do
                [pre_error,0]
            else
                [error,1]
            end
            [new_count,b3] =
            if count > String.to_integer(pre_count) do
                [count,1]
            else
                [pre_count,0]
            end
            [new_time,b4] =
            if time > String.to_integer(pre_time) or result != :completed do
                [pre_time,0]
            else
                [time,1]
            end
            ["#{new_exp}^#{new_error}^#{new_count}^#{new_time}^",b1,b2,b3,b4]
        end
        n_list =
        if !str or str =="" do
            Enum.map(list, fn x ->
                Enum.find_index(sent_list,&(&1 == x))
            end)
            |> Enum.sort()
        else
            pre_en = String.split(str,"^")
            |> Enum.at(4)
            |> String.split(":")
            |> Enum.map(&String.to_integer(&1))
            en_list = Enum.filter(list, fn x ->
               x not in pre_en
            end)
            |> Enum.map(fn x ->
                Enum.find_index(sent_list,&(&1 == x))
            end)
            Enum.uniq(pre_en ++ en_list)
            |> Enum.sort()
        end
        en = Enum.join(n_list,":")
        en = en <> "^"
        ce = String.split(misstypes,"\n")
        |> Enum.join("`")
        sentence = sent<>en<>ce<>"^"
        info = %{pre_info | to => sentence}
        CsvRead.info_renew(id,info)
        bools = [f1,f2,f3,f4]
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
            level_past: level_now,
            level: level_new,
            levelupflag: levelupflag,
            bools: bools
        ])
    end
end
