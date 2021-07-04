defmodule TypingMaojoWeb.MainLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    import TypingMaojoWeb.ErrorHelpers
    alias TypingMaojoWeb.MakeList

    def mount(_params,_session,socket) do
        connected?(socket) && :timer.send_interval(1000, :update)
        {:ok, first_socket(socket)}
    end

    def handle_info(:update, socket) do
        {:noreply, update_socket(socket)}
    end

    def handle_event("type", %{"key"=>"Escape"},socket) do
        {:noreply, update(socket, :escflag, & !&1)}
    end

    def handle_event("type",%{"key"=>"Shift"},socket) do
        {:noreply,socket}
    end

    def handle_event("type",%{"key"=>key},socket) do
        new_socket =
            if socket.assigns.escflag, do: socket, 
            else: update_sentence(socket,key)
        {:noreply, new_socket}
    end

    defp first_socket(socket) do
        value = 
        [
            num: 0,
            time: 0,
            sentence: MakeList.ex_sentence(0),
            typed: "",
            remain: MakeList.ex_sentence(0),
            sentence_at: 0,
            error_count: 0,
            escflag: false
        ]
        assign(socket,value)
    end

    defp update_socket(socket) do
        if socket.assigns.time > 59 do
            game_finish(socket,:finished)
        else
            if socket.assigns.escflag do
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
            num: number,
            error_count: error
        } 
        = socket.assigns

        expected_key = String.at(sentence,number)
        sentence_len = MakeList.sentence_length(at)
        {typed,remain} = String.split_at(sentence,number+1)
        
        if key == expected_key do
            if number == sentence_len do
                new_sentence = MakeList.ex_sentence(at+1)
                assign(socket, 
                [
                    sentence: new_sentence,
                    num: 0,
                    typed: "",
                    remain: new_sentence
                ])
                |> update(:sentence_at, &(&1 + 1))
            else
                if at == MakeList.list_length - 1 do
                    game_finish(socket,:completed)
                else
                    update(socket, :num, &(&1 + 1))
                    |> assign([
                        typed: typed, 
                        remain: remain
                    ])
                end
            end
        else    
            if error == 9 do
                update(socket, :error_count, &(&1 + 1))
                |> game_finish(:failed)
            else
                update(socket, :error_count, &(&1 + 1))
            end    
        end
    end

    defp game_finish(socket,atom) do
        %{
            error_count: error,
            time: time,
            sentence_at: at
        }
        =socket.assigns

        put_flash(socket,:result,atom)
        |> put_flash(:error,error)
        |> put_flash(:time,time)
        |> put_flash(:count, at + 1)
        |> redirect(to: "/game/finish")
    end    
end
