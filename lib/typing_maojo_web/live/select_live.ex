defmodule TypingMaojoWeb.SelectLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias TypingMaojoWeb.CsvRead
  alias TypingMaojoWeb.ListCharas

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
    {:ok,assign(socket,[charas: charas, flag: [false,false,false], status: ""])}
  end

  def handle_event("select",%{"id"=>id},socket) do
    number = String.to_integer(id)
    flags =
    Enum.map(1..3, fn x->
      x==number
    end)
    {:noreply, assign(socket,[flag: flags])}
  end
  def handle_event("delete",%{"id"=>id},socket) do
    {:noreply,assign(socket,status: "delete",id: id)}
  end

  def handle_event("start",%{"id"=>id},socket) do
    {:noreply,assign(socket,status: "new",id: id)}
  end

  def handle_event("delete-comp",%{"id"=>id},socket) do
    ListCharas.delete_chara(id)
    socket = put_flash(socket, :message, "データ#{id}を消去しました。")
    {:noreply,redirect(socket,to: "/game/select")}
  end

  def handle_event("delete-back",%{"id"=>id},socket) do
    number = String.to_integer(id)
    flags =
    Enum.map(1..3, fn x->
      x==number
    end)
    {:noreply, assign(socket,[flag: flags, status: ""])}
  end

  def handle_event("submit",%{"name"=>name,"id"=>id},socket) do
    CsvRead.chara_new(id,name)
    {:noreply,redirect(socket,to: "/game/area/#{id}")}
  end
end
