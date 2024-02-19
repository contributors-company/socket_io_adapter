part of 'socket_io_adapter.dart';

class SocketException implements Exception {
  final SocketResponse response;
  final StackTrace stackTrace;

  SocketException(this.response, this.stackTrace);

  @override
  String toString() {
    return 'SocketException{message: $response} \n ${stackTrace.toString()}';
  }
}
