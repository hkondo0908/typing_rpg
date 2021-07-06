defmodule TypingMaojoWeb.AreaLive do
    use Phoenix.LiveView
    use Phoenix.HTML

    def mount(%{"area"=>area},_session,socket) do
        {:ok, assign(socket,[area: area,cleared_stage: 0, cleared_area: 0])}
    end
end
