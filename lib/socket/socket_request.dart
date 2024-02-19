part of 'socket_io_adapter.dart';

/// [SocketRequest] is the request to the server.
/// It contains the event and the data to be sent to the server.
/// The data is a map of key-value pairs.

class SocketRequest {
  final String event;
  final Map<String, dynamic>? data;

  SocketRequest._({
    required this.event,
    this.data = const {},
  });

  SocketRequest.create(this.event, this.data);

  SocketRequest copyWith({String? event, Map<String, dynamic>? data}) {
    return SocketRequest._(event: event ?? this.event, data: data ?? this.data);
  }

  @override
  String toString() {
    return 'SocketRequest{event: $event, data: $data}';
  }
}
