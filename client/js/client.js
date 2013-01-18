// Generated by CoffeeScript 1.5.0-pre
(function() {
  var handleError, iosocket;

  handleError = function(state, message) {
    console.error(state);
    return console.error(message);
  };

  iosocket = io.connect();

  iosocket.on("connect", function() {
    handlers["connected"](iosocket);
    iosocket.on("message", function(message) {
      var parsed, respond;
      parsed = JSON.parse(message);
      if (parsed == null) {
        return handleError(message, "Received invalid JSON or empty message");
      } else if (parsed.method == null) {
        return handleError(message, "Message does not contain method property");
      } else if (toString.call(parsed.method) !== '[object String]') {
        return handleError(message, "Method property should be a string");
      } else if (parsed.args == null) {
        return handleError(message, "Message does not contain args property");
      } else if (!parsed.args instanceof Array) {
        return handleError(message, "Args property is not an array");
      } else if (handlers[parsed.method] == null) {
        return handleError(handlers, "Method: " + parsed.method + " is not defined");
      } else {
        respond = function(message) {
          return iosocket.send(message);
        };
        parsed.args.unshift(respond);
        try {
          return handlers[parsed.method].apply(handlers[parsed.method], parsed.args);
        } catch (err) {
          return handleError(err, "Method threw and exception");
        }
      }
    });
    iosocket.on("disconnect", function() {
      return handlers["disconnected"](iosocket);
    });
    return $('#outgoingChatMessage').keypress(function(event) {
      var test_message;
      if (event.which === 13) {
        event.preventDefault();
        test_message = {
          method: "test",
          args: [$('#outgoingChatMessage').val()]
        };
        iosocket.send(JSON.stringify(test_message));
        $('#incomingChatMessages').append($('<li></li>').text($('#outgoingChatMessage').val()));
        return $('#outgoingChatMessage').val('');
      }
    });
  });

}).call(this);
