part of 'socket_io_adapter.dart';

/// [SocketResponse] is the response from the server.
/// It contains the data returned from the server.
/// The data is a map of key-value pairs.
class SocketResponse {
  /// The data returned from the server.
  final Map<String, dynamic> data;

  SocketResponse(this.data);

  @override
  String toString() {
    return 'SocketResponse{data: $data}';
  }
}
