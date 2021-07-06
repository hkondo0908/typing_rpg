defmodule TypingMaojoWeb.MainLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    import TypingMaojoWeb.ErrorHelpers, warn: false
    alias TypingMaojoWeb.MakeList

    def mount(%{"stage"=> stage, "area" => area},_session,socket) do
        connected?(socket) && :timer.send_interval(1000, :update)
        {:ok, first_socket(socket,area,stage)}
    end

    def handle_info(:update, socket) do
        {:noreply, update_socket(socket)}
    end

    def handle_event("start", _,socket) do
        {:noreply, update(socket, :startflag, & !&1)}
    end

    def handle_event("type", %{"key"=>"Escape"},socket) do
        {:noreply, update(socket, :escflag, & !&1)}
    end

    def handle_event("type",%{"key"=>"Shift"},socket) do
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

    defp first_socket(socket,area,stage) do
        value =
        [
            area: area,
            stage: stage,
            num: 0,
            time: 0,
            max: MakeList.list_length(area,stage),
            sentence: MakeList.ex_sentence(area,stage,0),
            typed: "",
            remain: MakeList.ex_sentence(area,stage,0),
            sentence_at: 0,
            error_count: 0,
            escflag: false,
            misstypes: [],
            startflag: false
        ]
        assign(socket,value)
    end

    defp update_socket(socket) do
        if socket.assigns.time > 59 do
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
            area: area,
            stage: stage,
            sentence_at: at,
            sentence: sentence,
            num: number,
            error_count: error,
            max: max
        }
        = socket.assigns

        expected_key = String.at(sentence,number)
        sentence_len = MakeList.sentence_length(area,stage,at)
        {typed,remain} = String.split_at(sentence,number+1)

        if key == expected_key do
            if number == sentence_len do
                if at == max - 1 do
                    game_finish(socket,:completed)
                else
                    new_sentence = MakeList.ex_sentence(area,stage,at+1)
                    assign(socket,
                    [
                        sentence: new_sentence,
                        num: 0,
                        typed: "",
                        remain: new_sentence
                    ])
                    |> update(:sentence_at, &(&1 + 1))
                end
            else
                update(socket, :num, &(&1 + 1))
                |> assign([
                    typed: typed,
                    remain: remain
                ])
            end
        else
            socket = update(socket, :error_count, &(&1 + 1)) |> update(:misstypes, &[expected_key|&1])
            if error == 9 do
                game_finish(socket, :failed)
            else
                socket
            end

        end
    end

    defp game_finish(socket,atom) do
        %{
            area: area,
            stage: stage,
            error_count: error,
            time: time,
            sentence_at: at,
            misstypes: misstypes,
        }
        =socket.assigns

        misstypes =
        misstypes
        |> Enum.frequencies()
        |> Map.to_list()
        |> Enum.map(fn {k, v} ->  "#{k}$ #{v}" end)
        |> Enum.join("\n")

        put_flash(socket,:result,atom)
        |> put_flash(:error,error)
        |> put_flash(:time,time)
        |> put_flash(:count, at + 1)
        |> put_flash(:area, area)
        |> put_flash(:stage,stage)
        |> put_flash(:misstypes, misstypes)
        |> redirect(to: "/game/finish")
    end
end
