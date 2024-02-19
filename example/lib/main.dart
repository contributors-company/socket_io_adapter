import 'package:flutter/material.dart';
import 'package:socket_io_adapter/socket_io_adapter.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket IO Adapter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SocketIOAdapter? socket;
  String? answear;
  String? listenAnswear;

  void onPressed() {
    socket?.emit('event').then((response) {
      answear = response.data.toString();
    }).catchError((error) {
      if(error is SocketException) {
        answear = error.response.data.toString();
      } else {
        answear = error.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Socket Adapter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(listenAnswear ?? 'ListenAnswear'),

            Text(answear ?? 'Press the button to get an answear'),
            ElevatedButton(onPressed: onPressed, child: const Text('Emit event'))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    socket = SocketIOAdapter.initializeOptions(SocketIOOptions(path: ''));
    socket?.checkResponse = (data) => data['status']['ok'];
    socket?.connect(); //or socket.connect({'token': 'ACCESS TOKEN'});
    socket?.onAll({
      'disconnect': (data) => listenAnswear = 'Disconnected',
      'connect': (data) => listenAnswear = 'Connect',
      'error': (data) => listenAnswear = 'Error',
      'connect_error': (data) => listenAnswear = 'Connect Error',
      'your_event': (data) => listenAnswear = 'Your Event',
    });

    super.initState();
  }
}
