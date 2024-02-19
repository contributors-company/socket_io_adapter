part of 'socket_io_adapter.dart';

class SocketRequest {
  final String event;
  final Map<String, dynamic>? data;

  SocketRequest._({required this.event, this.data = const {}});

  SocketRequest.create(this.event, this.data);

  SocketRequest copyWith({String? event, Map<String, dynamic>? data}) {
    return SocketRequest._(event: event ?? this.event, data: data ?? this.data);
  }

  @override
  String toString() {
    return 'SocketRequest{event: $event, data: $data}';
  }
}
