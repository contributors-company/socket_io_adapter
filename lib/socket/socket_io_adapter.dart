import 'dart:async';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as io;

part 'socket_interceptor.dart';
part 'socket_response.dart';
part 'socket_request.dart';
part 'socket_exception.dart';
part 'socket_options.dart';

typedef EventCallback = Map<String, Function(dynamic data)>;

class SocketIOAdapter {
  io.Socket? _socket;
  SocketIOOptions options;
  List<SocketInterceptor> interceptors = [];
  bool Function(dynamic data) checkResponse = (data) => data['status']['ok'];


  SocketIOAdapter.initializeOptions(this.options);

  io.Socket get socket {
    try {
      return _socket!;
    } catch (e) {
      rethrow;
    }
  }

  connect([Map<String, dynamic>? auth]) {
    if (_socket != null || _socket?.active == true) return;
    late io.OptionBuilder optionBuilder;
    if(auth == null) {
      optionBuilder = options.toOptionBuilder();
    } else {
      optionBuilder = options.toOptionBuilder().setAuth(auth);
    }
    _socket = io.io(
      options.path,
      optionBuilder.build(),
    );
    _socket?.connect();
    _socket?.onDisconnect((data) {
      Future.delayed(Duration.zero).then((value) {
        if (_socket?.connected == false) _socket?.connect();
      });
    });
  }

  disconnect() => _socket?.dispose();

  Future<SocketResponse> emit(String event, [data]) async {
    Completer<SocketResponse> completer = Completer<SocketResponse>();
    SocketRequest request = SocketRequest.create(event, data);

    request = interceptors.fold(
        request, (request, interceptor) => interceptor.onRequest(request));
    _socket?.emitWithAck(request.event, request.data, ack: (data) {
      try {
        SocketResponse response = SocketResponse(data);
        if (checkResponse(data)) {
          response = interceptors.fold(response,
              (response, interceptor) => interceptor.onResponse(response));
          completer.complete(response);
        } else {
          _onError(data);
          completer
              .completeError(SocketException(response, StackTrace.current));
        }
      } catch (err) {
        completer.completeError(err);
      }
    });

    return completer.future;
  }

  _onError(dynamic error) {
    for (var interceptor in interceptors) {
      interceptor.onError(error);
    }
  }

  onAll(EventCallback callbacks) {
    callbacks.forEach((key, value) {
      _socket?.on(key, value);
    });
  }

  on(String event, Function(dynamic) callback) {
    _socket?.on(event, (data) {
      callback(data);
    });
  }
}
