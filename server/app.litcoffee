	fs = require "fs"
	connect = require "connect"
	socketio = require "socket.io"

	server = connect.createServer(
	  connect.static("#{__dirname}/../client/")
	).listen(8080)

	socketio.listen(server).on "connection", (socket) ->
	  socket.on "message", (msg) ->
	    console.log "Message Received"
	    socket.broadcast.emit("message",msg)