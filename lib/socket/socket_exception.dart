part of 'socket_io_adapter.dart';

/// [SocketException] is an exception that is thrown when an error occurs.
/// It contains the [response] from the server and the [stackTrace] of the error.
/// The [response] is the response from the server.
/// The [stackTrace] is the stack trace of the error.

class SocketException implements Exception {
  /// The response from the server.
  final SocketResponse response;
  /// The stack trace of the error.
  final StackTrace stackTrace;

  SocketException(this.response, this.stackTrace);

  @override
  String toString() {
    return 'SocketException{message: $response} \n ${stackTrace.toString()}';
  }
}
