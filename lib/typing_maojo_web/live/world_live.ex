defmodule TypingMaojoWeb.WorldLive do
    use Phoenix.LiveView
    use Phoenix.HTML

    def mount(_param,_session,socket) do
        {:ok, assign(socket,[area: 1])}
    end

end