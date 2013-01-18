// this handlers object is where my socket.io client

var handlers = {}

// handlers should be of the form
// handlers.<method> = function(respond,args...) { ... }
// the respond method can be used to send a string back to the server

handlers.connected = function (respond) {
	console.log("Connected");
  	$('#disconnected-overlay').hide()
  	// here we would hook up "client side" events (things like buttons) to the respond method
}

handlers.disconnected = function(respond){
	console.log("Disconnected");
    $('#disconnected-overlay').show()
    // here we would disconnect our client side events from the respond method
}

// note this only works now because we broadcast all messages received from a client to all other clients
// it wont work like this once we get some real datasources generating events

handlers.test = function (respond, message) {
    $('#incomingChatMessages').append($('<li></li>').text(message));

    if(message.toUpperCase() === "MARCO") {

    	polo_message = {method:"test", args: ["POLO!"]};

      	respond(JSON.stringify(polo_message));
  	}
}