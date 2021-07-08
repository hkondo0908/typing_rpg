defmodule TypingMaojoWeb.MainLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    import TypingMaojoWeb.ErrorHelpers, warn: false
    alias TypingMaojoWeb.MakeList
    alias TypingMaojoWeb.ListCharas
    alias TypingMaojoWeb.Levels
    alias TypingMaojoWeb.Stages

    def mount(%{"stage"=> stage, "area" => area, "id" => id},_session,socket) do
        connected?(socket) && :timer.send_interval(1000, :update)
        {:ok, first_socket(socket,area,stage,id)}
    end

    def handle_info(:update, socket) do
        {:noreply, update_socket(socket)}
    end

    def handle_info(:miss, socket) do
        {:noreply, assign(socket, missflag: false)}
    end

    def handle_info(:finish, socket) do
        {:noreply, assign(socket, endflag: true)}
    end

    def handle_event("start", _,socket) do
        {:noreply, update(socket, :startflag, & !&1)}
    end

    def handle_event("type", %{"key"=>"Escape"},socket) do
        {:noreply, update(socket, :escflag, & !&1)}
    end

    def handle_event("type",%{"key"=>key},socket) when key in ["Shift","Enter","BackSpace"] do
        {:noreply,socket}
    end

    def handle_event("type",%{"key"=>" "},socket) do
        socket =
        if !socket.assigns.startflag do
            assign(socket,startflag: true)
        else
            if socket.assigns.escflag, do: socket,
            else: update_sentence(socket," ")
        end
        {:noreply, socket}
    end

    def handle_event("type",%{"key"=>key},socket) do
        new_socket =
            if !socket.assigns.startflag or socket.assigns.escflag, do: socket,
            else: update_sentence(socket,key)
        {:noreply, new_socket}
    end

    defp first_socket(socket,area,stage,id) do
        sentence_list = MakeList.list_up(area,stage)
        |> Enum.map(fn [_,_,s] ->
           s
        end)
        value =
        [
            sentence_list: sentence_list,
            id: id,
            area: area,
            stage: stage,
            num: 0,
            time: 0,
            max: length(sentence_list),
            sentence: Enum.at(sentence_list,0),
            typed: "",
            remain: Enum.at(sentence_list,0),
            sentence_at: 0,
            error_count: 0,
            escflag: false,
            misstypes: [],
            enemy: 1,
            startflag: false,
            missflag: false,
            endflag: false
        ]
        assign(socket,value)
    end

    defp update_socket(socket) do
        if socket.assigns.time > String.to_integer(socket.assigns.stage)*60-1 do
            game_finish(socket,:finished)
        else
            if !socket.assigns.startflag or socket.assigns.escflag do
                socket
            else
               update(socket, :time, & &1 + 1)
            end
        end
    end

    def update_sentence(socket,key) do
        %{
            sentence_at: at,
            sentence: sentence,
            sentence_list: sentence_list,
            num: number,
            error_count: error,
            max: max
        }
        = socket.assigns


        socket = assign(socket, missflag: false)
        expected_key = String.at(sentence,number)
        sentence_len = String.length(sentence)
        {typed,remain} = String.split_at(sentence,number+1)

        if key == expected_key do
            if number == sentence_len - 1 do
                if at == max - 1 do
                    update(socket,:sentence_at, &(&1 + 1))
                    |> game_finish(:completed)
                else
                    new_sentence =
                    Enum.at(sentence_list,at+1)
                    assign(socket,
                    [
                        sentence: new_sentence,
                        num: 0,
                        typed: "",
                        remain: new_sentence
                    ])
                    |> update(:sentence_at, & &1 + 1)
                    |> update(:enemy, & &1 + 1)
                end
            else
                update(socket, :num, &(&1 + 1))
                |> assign([
                    typed: typed,
                    remain: remain
                ])
            end
        else
            socket =
                update(socket, :error_count, &(&1 + 1))
                |> update(:misstypes, &[expected_key|&1])
                |> assign(missflag: true)
            if error == 9 do
                game_finish(socket, :failed)
            else
                :timer.send_after(1000,:miss)
                socket
            end

        end
    end

    defp game_finish(socket,atom) do
        :timer.send_after(1000,:finish)

        %{
            area: area,
            stage: stage,
            error_count: error,
            time: time,
            sentence_at: at,
            misstypes: misstypes,
            id: id,
            sentence_list: sentence_list
        }
        =socket.assigns

        misstypes =
        misstypes
        |> Enum.frequencies()
        |> Map.to_list()
        |> Enum.map(fn {k, v} ->  "#{k}$ #{v}" end)
        |> Enum.join("\n")

        sentence_list = Enum.take(sentence_list, at)

        %{"経験値" => _exp_now, "レベル" => level_now} = ListCharas.find_chara(id)
        exp = (Stages.find_exp(area,stage)) * at
        Levels.level_up(id,exp)

        :timer.sleep(3000)
        put_flash(socket,:result,atom)
        |> put_flash(:error,error)
        |> put_flash(:time,time)
        |> put_flash(:count, at)
        |> put_flash(:exp, exp)
        |> put_flash(:misstypes, misstypes)
        |> put_flash(:sentence_list, sentence_list)
        |> put_flash(:level_now, level_now)
        |> redirect(to: "/game/finish/#{id}/#{area}/#{stage}")
    end

end
