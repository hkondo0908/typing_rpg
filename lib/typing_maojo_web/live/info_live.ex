defmodule TypingMaojoWeb.InfoLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias TypingMaojoWeb.ListCharas
  def mount(%{"id"=>id},_session,socket) do
    chara = ListCharas.find_chara(id)
    level = chara["レベル"]
    stage = chara["到達ステージ"]
    area = chara["到達エリア"]

    {:ok,assign(socket,id: id, level: level, stage: stage, area: area)}
  end


end
