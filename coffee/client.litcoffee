
  iosocket =  io.connect()

  iosocket.on "connect", () ->
    $('#incomingChatMessages').append($('<li>Connected</li>'))

    iosocket.on "message", (message) ->
      $('#incomingChatMessages').append($('<li></li>').text(message))

    iosocket.on "disconnect" , () ->
      $('#incomingChatMessages').append('<li>Disconnected</li>')

    $('#outgoingChatMessage').keypress (event) ->
      if event.which == 13
        event.preventDefault()
        iosocket.send($('#outgoingChatMessage').val())
        $('#incomingChatMessages').append($('<li></li>').text($('#outgoingChatMessage').val()))
        $('#outgoingChatMessage').val('')