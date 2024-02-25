part of 'socket_io_adapter.dart';

/// [SocketIOOptions] is the options for the socket.
/// It contains the path, transports, headers, and timeout.
/// The path is the path to the server.
/// The transports are the transports to be used.
/// The headers are the headers to be sent to the server.
/// The timeout is the timeout for the socket.

class SocketIOOptions {
  /// The path to the server.
  final String path;

  /// The transports to be used.
  final List<String> transports;

  /// The headers to be sent to the server.
  final Map<String, dynamic> headers;

  /// The timeout for the socket.
  final int timeout;

  SocketIOOptions({
    required this.path,
    this.transports = const ['websocket'],
    this.timeout = 900000, // 15 minutes
    this.headers = const {'accept': 'application/json'},
  });


  /// [toOptionBuilder] is a method that converts the [SocketIOOptions] to an [io.OptionBuilder].
  io.OptionBuilder toOptionBuilder() {
    return io.OptionBuilder()
        .setTransports(transports)
        .setTimeout(timeout)
        .setExtraHeaders(headers);
  }
}
