import 'package:socket_io_adapter/socket/socket_io_adapter.dart';

export 'package:socket_io_adapter/socket/socket_io_adapter.dart';

main (){
  final socket = SocketIOAdapter.initializeOptions(SocketIOOptions(path: ''));
  socket.checkResponse = (data) => data['status']['ok'];
}