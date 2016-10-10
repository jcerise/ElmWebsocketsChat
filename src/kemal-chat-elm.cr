require "kemal"

SOCKETS = [] of HTTP::WebSocket

ws "/chat" do |socket|
  # Add the client to the SOCKETS list
  SOCKETS << socket

  # Broadcast each messag to all clients
  socket.on_message do |message|
    SOCKETS.each { |socket| socket.send message}
  end

  # Remove clients from the list when closed
  socket.on_close do
    SOCKETS.delete socket
  end
end

Kemal.run
