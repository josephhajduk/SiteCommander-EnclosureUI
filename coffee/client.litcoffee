Here client side Socket.IO socket is setup and events are defined

First we define our error handling function, simple now but we may change 
it later
    
    handleError = (state, message) ->
      console.error state
      console.error message


We create a new socket.

    iosocket =  io.connect()

We then define the "connect" handler, which is called exactly when you think 
it would be called.  We pass on the connected event before we do anything else.

    iosocket.on "connect", () ->
      handlers["connected"](iosocket)

We then define the handler for the message event, note all the following 
hanlders are defined within the "connect" handler

      iosocket.on "message", (message) ->

We attempt to parse the message as JSON.  

        parsed = JSON.parse(message)

        if not parsed?
          handleError message,"Received invalid JSON or empty message"

We then verify that the parsed json contains a methodname property that
is a string,  and a args property that is an Array

        else if not parsed.method?
          handleError message, "Message does not contain method property"
        else if toString.call(parsed.method) != '[object String]'
          handleError message, "Method property should be a string"
        else if not parsed.args?
          handleError message, "Message does not contain args property"
        else if not parsed.args instanceof Array
          handleError message, "Args property is not an array"


We then call the appropriate method after we verify that it exists.  
We send a reference to the socket as well as the arguments

        else if not handlers[parsed.method]? 
          handleError handlers, "Method: #{parsed.method} is not defined"
        else

          respond = (message) ->
            iosocket.send(message)

          parsed.args.unshift(respond)
          
          try
            handlers[parsed.method].apply(handlers[parsed.method],parsed.args)
          catch err
            handleError err, "Method threw and exception"
        
We also pass along the disconnect handler

      iosocket.on "disconnect" , () ->
        handlers["disconnected"](iosocket)





















### TESTING ###

We will leave the textbox in for testing.

      $('#outgoingChatMessage').keypress (event) ->

If the enter key is pressed we send a simple text message back to the server,  
as we extend this we will need to packaged our message up as JSON

        if event.which == 13
          event.preventDefault()

          test_message = 
            method: "test"
            args: [
              $('#outgoingChatMessage').val()
            ]

          iosocket.send(JSON.stringify(test_message))

We add the message that we sent to the server to our list of chat messages aswell.

          $('#incomingChatMessages').append($('<li></li>').text($('#outgoingChatMessage').val()))

We then clear our chat message box

          $('#outgoingChatMessage').val('')