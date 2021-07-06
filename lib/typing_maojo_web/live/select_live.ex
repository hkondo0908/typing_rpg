defmodule TypingMaojoWeb.SelectLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias TypingMaojoWeb.CsvRead

  def mount(_params,_session,socket) do
    charas =
    CsvRead.read_chara
    |> Enum.map(&[&1["名前"],&1["レベル"],&1["経験値"],&1["到達ステージ"]])
    |> Enum.map(fn [n,l,e,r] ->
      if l=="" do
        "NO DATA"
      else
        "name: #{n}\n level: #{l}\n exp: #{e}\n area: #{r}"
      end
    end)
    charas =
    charas
    |> Enum.map(fn x ->
      if x=="NO DATA" do
        [false , x]
      else
        [true , x]
      end
    end)
    {:ok,assign(socket,[charas: charas, flag: [false,false,false]])}
  end

  def handle_event("start",%{"id"=>id,"bool"=>bool},socket) do
    number = String.to_integer(id)
    socket =
    if bool=="true" do
      redirect(socket, to: "/game/area/#{id}")
    else
      flags =
      Enum.map(1..3, fn x->
        x==number
      end)
      assign(socket,[flag: flags])
    end
    {:noreply, socket}
  end
  def handle_event("submit",%{"name"=>name,"id"=>id},socket) do
    CsvRead.chara_new(id,name)
    {:noreply,socket}
  end

end
