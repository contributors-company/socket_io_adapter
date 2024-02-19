part of 'socket_io_adapter.dart';

class SocketIOOptions {
  final String path;
  final List<String> transports;
  final Map<String, dynamic> headers;
  final int timeout;

  SocketIOOptions({
    required this.path,
    this.transports = const ['websocket'],
    this.timeout = 900000, // 15 minutes
    this.headers = const {HttpHeaders.acceptHeader: 'application/json'}
  });

  io.OptionBuilder toOptionBuilder() {
    return io.OptionBuilder()
        .setTransports(transports)
        .setTimeout(timeout)
        .setExtraHeaders(headers);
  }
}