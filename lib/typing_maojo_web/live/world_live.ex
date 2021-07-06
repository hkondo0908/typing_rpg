defmodule TypingMaojoWeb.WorldLive do
    use Phoenix.LiveView
    use Phoenix.HTML

    def mount(%{"id"=>id},_session,socket) do
        {:ok, assign(socket,[id: id])}
    end

end
