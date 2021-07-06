defmodule TypingMaojoWeb.AreaLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.ListCharas

    def mount(%{"id"=>id,"area"=>area},_session,socket) do
        %{"到達エリア"=>cleared_area, "到達ステージ"=>cleared_stage} = ListCharas.find_chara(id)
        {:ok, assign(socket,[area: area,cleared_stage: cleared_stage, cleared_area: cleared_area, id: id])}
    end
end
