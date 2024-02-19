part of 'socket_io_adapter.dart';

/// [SocketInterceptor] is an abstract class that can be used to intercept
/// requests and responses to and from the server.
/// It contains the [onRequest], [onResponse], and [onError] methods.
/// The [onRequest] method is called before the request is sent to the server.
/// The [onResponse] method is called after the response is received from the server.
/// The [onError] method is called when an error occurs.

abstract class SocketInterceptor {
  SocketRequest onRequest(SocketRequest request) {
    return request;
  }

  SocketResponse onResponse(SocketResponse response) {
    return response;
  }

  void onError(dynamic error) {}
}
