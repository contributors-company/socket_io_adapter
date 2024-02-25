
## Getting started

```shell
flutter pub add socket_io_adapter
```

### And full installation of [socket_io_client](https://pub.dev/packages/socket_io_client#troubleshooting) via the link

## Usage


```dart
final socket = SocketIOAdapter.initializeOptions(SocketIOOptions(path: 'https://example.com:3000/'));
socket.checkResponse = (data) => data['status']['ok']; // this is method for checking response from server. You can use custom method for checking response
socket.connect();
socket.onAll({
    'disconnect': (data) => print('Disconnect'),
    'connect': (data) => print('Connect'),
    'error': (data) => print('Error'),
    'connect_error': (data) => print('Connect Error'),
    'your_event': (data) => print('Your Event'),
});
socket.on('connect', (data) => print('Connect 2'));
```


## Emit
```dart
socket.emit('sendMessage', {'message' : 'hi'}).then((value) {
    this.value = value;
}).catchError((error) {
    print('Error: ${error}')
});


```





## Interceptor for socket
```dart

class LoggerSocketInterceptor extends SocketInterceptor {
  @override
  SocketRequest onRequest(SocketRequest request) {
    print('On Request: ${[request.data, request.event]}');
    return super.onRequest(request);
  }

  @override
  SocketResponse onResponse(SocketResponse response) {
    print('On Response: ${response.data}');
    return super.onResponse(response);
  }

  @override
  void onError(error) {
    print(error);
    super.onError(error);
  }

  @override
  dynamic onEvent(event, data) {
    print('Event: ${[event, data]}');
    super.onEvent(event, data);
  }
}

```

### print console log
```shell
On Request: [ 'sendMessage', {'message' : 'hi'} ]
On Response: { 'status': { 'ok': true }, 'data': { 'id': 'number', 'message': 'hi' } }
Event: [ 'reveiveMessage', { 'id': 'number', 'message': 'Hi!' } ]
```