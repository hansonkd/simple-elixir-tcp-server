defmodule SimpleTCP.Sender do
  use GenServer
  import Socket

  def start_link(socket, opts \\ []) do
    GenServer.start_link(__MODULE__, [socket: socket], opts)
  end

  def init(socket) do
    # Register the process with gproc and subcscribe to :something
    :gproc.reg({:p, :l, :something})
    {:ok, socket}
  end

  def handle_cast({:msg, msg}, [socket: socket] = state) do
    Socket.Stream.send(socket, msg)
    {:noreply, state}
  end
end
