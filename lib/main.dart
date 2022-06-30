import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Ejemplo Flutter to Apple Watch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final channel = const MethodChannel('com.sofkaexample.watch');
  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await channel.invokeMethod(
        "flutterToWatch", {"method": "sendCounterToNative", "data": _counter});
  }

  Future<void> _initFlutterChannel() async {
    channel.setMethodCallHandler((call) async {
      // Receive data from Native
      switch (call.method) {
        case "sendCounterToFlutter":
          _counter = call.arguments["data"]["counter"];
          _incrementCounter();
          break;
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initFlutterChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: const Color.fromRGBO(6, 6, 52, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                child: Image.network(
                    "https://www.sofka.com.co/wp-content/uploads/2020/09/logo-sofka-blanco-1.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Al presionar el (+) enviara el resultado del contador al Apple Watch',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
