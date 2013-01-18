This application will feed realtime status messages to web applications,  and handle feedback from these applications appropriately

	fs = require "fs"
	connect = require "connect"
	socketio = require "socket.io"

Here we create a simple server that will serve all the static files in the client folder,  we wont be using any fancy template system as all non static data will be fed into the system by socket.io

	server = connect.createServer(
	  connect.static("#{__dirname}/../client/")
	).listen(8080) #TODO:  We should pull the port from some form of configuration file

Here we setup our Socket.IO socket and define our message handlers

	socketio.listen(server).on "connection", (socket) ->

Here we handle incoming messages,  currently we simply log the message to the console then broadcast it back out to everyone else attached to the socket.

	  socket.on "message", (msg) ->
	    console.log "Message Received: #{msg}"
	    socket.broadcast.emit("message",msg)