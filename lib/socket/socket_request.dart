part of 'socket_io_adapter.dart';

/// [SocketRequest] is the request to the server.
/// It contains the event and the data to be sent to the server.
/// The data is a map of key-value pairs.

class SocketRequest {
  /// The event to be sent to the server.
  final String event;

  /// The data to be sent to the server.
  final Map<String, dynamic>? data;

  SocketRequest._({
    required this.event,
    this.data = const {},
  });

  /// [create] is a factory constructor that creates a [SocketRequest] with the given [event] and [data].
  SocketRequest.create(this.event, this.data);

  /// [copyWith] is a method that creates a new [SocketRequest] with the given [event] and [data].
  SocketRequest copyWith({String? event, Map<String, dynamic>? data}) {
    return SocketRequest._(event: event ?? this.event, data: data ?? this.data);
  }

  @override
  String toString() {
    return 'SocketRequest{event: $event, data: $data}';
  }
}
