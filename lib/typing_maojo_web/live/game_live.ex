defmodule TypingMaojoWeb.GameLive do
    use Phoenix.LiveView
    use Phoenix.HTML 
    import TypingMaojoWeb.ErrorHelpers

    @timeout Float.round(1_000_000 / 60) |> trunc
    def mount(_params,_session,socket) do
        time = :erlang.system_time
        connected?(socket) && MicroTimer.send_every(@timeout, :update)
        new_socket = assign(socket, [sentence: 0, num: 0, time: time])
        {:ok, update_socket(new_socket)}
    end

    def handle_info(:update, socket) do
        {:noreply, update_socket(socket)}
    end

    def handle_event("type",%{"key"=>"Shift"},socket) do
        {:noreply, socket}
    end
    def handle_event("type",%{"key"=>fight,"char"=>forw,"finish"=>finish},socket) do
        pre_text = fight
        finish = String.to_integer(finish)
        number = socket.assigns.num
        new_socket =
        if pre_text == forw and number == (finish-1) do
            update(socket, :sentence,&(&1 + 1))
            |> assign(num: 0) 
        else
            if pre_text == forw do
                update(socket, :num, &(&1 + 1))
            else
                socket
            end
        end
         {:noreply, assign(new_socket, ch: pre_text)}
    end

    defp update_socket(socket) do
        socket
        |> assign(:erlang_system_time, get_erlang_system_time())
    end

    defp get_erlang_system_time() do
        :erlang.system_time
    end

end