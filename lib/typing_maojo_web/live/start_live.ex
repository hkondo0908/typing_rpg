defmodule TypingMaojoWeb.StartLive do
    use Phoenix.LiveView
    use Phoenix.HTML
    alias TypingMaojoWeb.MakeList 
    def mount(_params,_session,socket) do
       {:ok, socket} 
    end


end