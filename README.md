

## Getting started

```shell
flutter pub add socket_io_adapter
```

### And full installation of [socket_io_client](https://pub.dev/packages/socket_io_client) via the link 

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
```


