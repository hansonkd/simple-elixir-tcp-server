defmodule SimpleTCP.Worker do

  import Socket

  def start_link(port) do
    pid = spawn_link(fn -> init(port) end)
    {:ok, pid}
  end

  def init(port) do
    server = Socket.TCP.listen!(port, [packet: :line])
    loop_connection(server)
  end

  defp loop_connection(server) do

    # Accept a TCP connection
    client = Socket.TCP.accept!(server)

    # Start our listening process in another process so it doesn't block
    spawn(fn() -> init_listener(client) end)

    # Get the next connection
    loop_connection(server)
  end

  def init_listener(client) do

    # Start our sending process.
    {:ok, _pid} = SimpleTCP.Sender.start_link(client)
    listen_for_msg(client)

  end

  defp listen_for_msg(client) do

    case Socket.Stream.recv(client) do
      { :ok, data } ->
        # Use gproc to cast the message {:msg, data} to everyone subscribed to :something
        GenServer.cast({:via, :gproc, {:p, :l, :something}}, {:msg, data})
        # Loop for another message
        listen_for_msg(client)
      { :error, :closed } -> :ok
      other -> IO.inspect other
    end
    
  end

end
