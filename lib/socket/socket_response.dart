part of 'socket_io_adapter.dart';

class SocketResponse {
  final Map<String, dynamic> data;

  SocketResponse(this.data);

  @override
  String toString() {
    return 'SocketResponse{data: $data}';
  }
}
