defmodule TypingMaojoWeb.GameLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    import TypingMaojoWeb.ErrorHelpers
    alias TypingMaojoWeb.MakeList

    @timeout Float.round(1_000_000 / 60) |> trunc
    def mount(_params,_session,socket) do
        time = :erlang.system_time
        connected?(socket) && MicroTimer.send_every(@timeout, :update)
        sentence = MakeList.ex_sentence(0)
        new_socket = assign(socket, [num: 0, time: time, sentence: sentence, sentence_at: 0, error_count: 0])
        {:ok, update_socket(new_socket)}
    end

    def handle_info(:update, socket) do
        {:noreply, update_socket(socket)}
    end

    def handle_event("type",%{"key"=>pre_text,"char"=>forw,"finish"=>finish},socket) do
        list = MakeList.list_up
        list_length = length(list)
        finish = String.to_integer(finish)
        number = socket.assigns.num
        at = socket.assigns.sentence_at
        new_socket =
        if pre_text == forw and number == (finish-1) do
            assign(socket, sentence: MakeList.ex_sentence(at + 1))
            |> update(:sentence_at, &(&1 + 1))
            |> assign(num: 0)
        else
            if pre_text == forw do
                update(socket, :num, &(&1 + 1))
            else
                if pre_text == "Shift" do
                    socket
                else
                    update(socket, :error_count, &(&1 + 1))
                end
            end
        end
        sentence_num = new_socket.assigns.sentence_at
        new_socket =
        if sentence_num == list_length  do
            redirect(socket, to: "/game/finish")
        else
            assign(new_socket, ch: pre_text)
        end
        {:noreply, new_socket}
    end

    defp update_socket(socket) do
        socket = assign(socket, :erlang_system_time, get_erlang_system_time())
        if div(get_erlang_system_time() - socket.assigns.time, 1000000000) > 60 do
            redirect(socket, to: "/game/finish")
        else
            socket
        end
    end

    defp get_erlang_system_time() do
        :erlang.system_time
    end

end
