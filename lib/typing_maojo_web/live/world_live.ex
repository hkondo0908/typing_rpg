defmodule TypingMaojoWeb.WorldLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.ListCharas, warn: false

    def mount(%{"id"=>id},_session,socket) do
        IO.puts(id)
        #%{"到達ステージ"=>cleared_stage,"到達エリア"=>cleared_area} = ListCharas.find_chara(id)
        {:ok, assign(socket,[id: id, cleared_stage: 0, cleared_area: 0])}
    end

end
