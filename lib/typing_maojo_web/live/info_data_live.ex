defmodule TypingMaojoWeb.InfoDataLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias TypingMaojoWeb.CsvRead
  alias TypingMaojoWeb.ListCharas
  alias TypingMaojoWeb.Information
  def mount(%{"id"=>id,"area"=>area, "stage"=>stage},_session,socket) do
    chara = ListCharas.find_chara(id)
    level = chara["レベル"]
    info = Information.find_info(id)
    infos = Enum.map(1..8, fn x->
      info["m#{x}"]
      |> String.split("^")
    end)
    sentence_list = CsvRead.read_CSV()

    {:ok,assign(socket,id: id, area: area, stage: stage, level: level, info: infos, list: sentence_list)}
  end


end
