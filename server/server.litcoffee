This application will feed realtime status messages to web applications,  and handle feedback from these applications appropriately

	fs = require "fs"
	connect = require "connect"
	https = require 'https'
	socketio = require "socket.io"
	mdns = require 'mdns'
	os = require 'os'

Configuration is stored in config.coffee

	config = require "./config.coffee"

Here we create a simple server that will serve all the static files in the client folder,  we wont be using any fancy template system as all non static data will be fed into the system by socket.io

SSL certificates are pulled from the config

	https_options = 
		key: fs.readFileSync("#{__dirname}/#{config.privatekey}")
		cert: fs.readFileSync("#{__dirname}/#{config.cert}")

	connect_server = connect.createServer(
	  		connect.static("#{__dirname}/../client/")
	)

	server = https.createServer(
			https_options,
			connect_server
		).listen(config.port)

We publish our existance with mdns
Towers will close all inbound ports after some period (say 120 seconds) after booting unless someone connects,  after that they will continually scan mdns for a controller.  
We will sign certs of the controllers for the towers.  Also client applications will also need signed certs.

	prefered_ip = ""

	for address in os.networkInterfaces()[config.pref_eth]
		if address.family == config.pref_family
			prefered_ip = address.address

	mdns_txt = 
		version: "0.1"
		role: "controller"
		uid: config.uid
		url: "https://#{prefered_ip}:#{config.port}/"

	mdns_ad = mdns.createAdvertisement(mdns.tcp('socketio-http'), 8080, {txtRecord: mdns_txt})

	mdns_ad.start()

Here we setup our Socket.IO socket and define our message handlers

	socketio.listen(server).on "connection", (socket) ->

Here we handle incoming messages,  currently we simply log the message to the console then broadcast it back out to everyone else attached to the socket.

	  socket.on "message", (msg) ->
	    console.log "Message Received: #{msg}"
	    socket.broadcast.emit("message",msg)