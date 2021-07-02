defmodule TypingMaojoWeb.FinishLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    def mount(_params,_session,socket) do
        IO.inspect(socket)
        {:ok,socket}
    end
end