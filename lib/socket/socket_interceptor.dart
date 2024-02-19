part of 'socket_io_adapter.dart';

abstract class SocketInterceptor {
  SocketRequest onRequest(SocketRequest request) {
    return request;
  }

  SocketResponse onResponse(SocketResponse response) {
    return response;
  }

  void onError(dynamic error) {}
}
