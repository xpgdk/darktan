defmodule DarktanWeb.PageController do
  use DarktanWeb, :controller

  alias Darktan.Store

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    keys =
      Store.list_keys()
      |> Enum.map(&to_string/1)

    render(conn, "index.html", %{keys: keys})
  end

  def add_value(conn, %{"key" => key, "value" => value}) do
    Store.put(key, value)
    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
