defmodule AttendWeb.PageController do
  use AttendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
