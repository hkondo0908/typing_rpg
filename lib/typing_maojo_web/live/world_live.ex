defmodule TypingMaojoWeb.WorldLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.ListCharas

    def mount(%{"id"=>id},_session,socket) do
        IO.inspect(ListCharas.find_chara(id))
        %{"到達ステージ"=>cleared_stage,"到達エリア"=>cleared_area} = ListCharas.find_chara(id)
        {:ok, assign(socket,[id: id, cleared_stage: cleared_stage, cleared_area: cleared_area])}
    end

end
