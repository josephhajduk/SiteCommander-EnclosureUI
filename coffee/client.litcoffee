Here client side Socket.IO socket is setup and events are defined
First we create a new socket.

    iosocket =  io.connect()

We then define the "connect" event, which is called exactly when you think it would be called

    iosocket.on "connect", () ->

Once we are connected we let the user know be adding a "Connected" row to the chat messages list

      $('#incomingChatMessages').append($('<li>Connected</li>'))

We then define the handler for the message event,  which is simply to add the message to the messages list

      iosocket.on "message", (message) ->
        $('#incomingChatMessages').append($('<li></li>').text(message))

We also define a disconnect handler

      iosocket.on "disconnect" , () ->
        $('#incomingChatMessages').append('<li>Disconnected</li>')

Finally we add a keypress event to our chat message box.

      $('#outgoingChatMessage').keypress (event) ->

If the enter key is pressed we send a simple text message back to the server,  as we extend this we will need to packaged our message up as JSON

        if event.which == 13
          event.preventDefault()
          iosocket.send($('#outgoingChatMessage').val())

We add the message that we sent to the server to our list of chat messages aswell.

          $('#incomingChatMessages').append($('<li></li>').text($('#outgoingChatMessage').val()))

We then clear our chat message box

          $('#outgoingChatMessage').val('')