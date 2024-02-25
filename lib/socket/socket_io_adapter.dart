import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

part 'socket_interceptor.dart';
part 'socket_response.dart';
part 'socket_request.dart';
part 'socket_exception.dart';
part 'socket_options.dart';

/// [EventCallback] is a map of event names and their respective callback functions.
/// The callback function takes a dynamic data as an argument.

typedef EventCallback = Map<String, Function(dynamic data)>;

/// [SocketIOAdapter] is a class that wraps the socket.io client.
/// It provides a simple interface to connect, disconnect, emit events and listen to events.
/// It also provides a way to intercept requests and responses.
/// The [options] is the options for the socket.
/// The [interceptors] is a list of [SocketInterceptor]s to intercept requests and responses.
/// The [checkResponse] is a function that checks if the response from the server is valid.
/// It takes a dynamic data as an argument and returns a boolean.
/// By default, it checks if the status.ok field is true.

class SocketIOAdapter {
  io.Socket? _socket;
  SocketIOOptions options;
  List<SocketInterceptor> interceptors = [];
  bool Function(dynamic data) checkResponse = (data) => data['status']['ok'];

  SocketIOAdapter.initializeOptions(this.options);

  io.Socket get socket {
    try {
      return _socket!;
    } catch (e) {
      rethrow;
    }
  }

  /// [connect] connects to the server using the given [auth] parameters.
  /// If the [auth] is null, it uses the options to connect.
  /// If the [auth] is not null, it uses the options and the [auth] to connect.
  /// If the socket is already connected, it does nothing.

  connect([Map<String, dynamic>? auth]) {
    if (_socket != null || _socket?.active == true) return;
    late io.OptionBuilder optionBuilder;
    if (auth == null) {
      optionBuilder = options.toOptionBuilder();
    } else {
      optionBuilder = options.toOptionBuilder().setAuth(auth);
    }
    _socket = io.io(
      options.path,
      optionBuilder.build(),
    );
    _socket?.connect();
    _socket?.onDisconnect((data) {
      Future.delayed(Duration.zero).then((value) {
        if (_socket?.connected == false) _socket?.connect();
      });
    });
  }

  disconnect() => _socket?.dispose();

  /// [emit] emits an event to the server with the given [event] and [data].
  /// It returns a [Future] of [SocketResponse].
  /// It uses the [interceptors] to intercept the request and response.
  /// It uses the [checkResponse] to check if the response is valid.
  /// If the response is valid, it returns the response.
  /// If the response is not valid, it throws a [SocketException].
  /// If an error occurs, it throws the error.
  Future<SocketResponse> emit(String event, [data]) async {
    Completer<SocketResponse> completer = Completer<SocketResponse>();
    SocketRequest request = SocketRequest.create(event, data);

    request = interceptors.fold(
      request,
      (request, interceptor) => interceptor.onRequest(request),
    );
    _socket?.emitWithAck(request.event, request.data, ack: (data) {
      try {
        SocketResponse response = SocketResponse(data);
        if (checkResponse(data)) {
          response = interceptors.fold(
            response,
            (response, interceptor) => interceptor.onResponse(response),
          );
          completer.complete(response);
        } else {
          for (var interceptor in interceptors) {
            interceptor.onError(data);
          }
          completer.completeError(
            SocketException(response, StackTrace.current),
          );
        }
      } catch (err) {
        completer.completeError(err);
      }
    });

    return completer.future;
  }

  /// [onAll] listens to all the events in the [callbacks].
  /// It takes a [EventCallback] as an argument.
  /// The [EventCallback] is a map of event names and their respective callback functions.
  onAll(EventCallback callbacks) {
    callbacks.forEach((key, value) {
      _socket?.on(key, value);
    });
  }

  /// [on] listens to the [event] and calls the [callback] when the event occurs.
  /// It takes a [String] event and a [Function] callback as arguments.
  /// The [Function] callback takes a dynamic data as an argument.
  /// It uses the [interceptors] to intercept the event data.
  on(String event, Function(dynamic) callback) {
    _socket?.on(event, (data) {
      callback(
        interceptors.fold(
          data,
          (data, interceptor) => interceptor.onEvent(event, data),
        ),
      );
    });
  }
}
