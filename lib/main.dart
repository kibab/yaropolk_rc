import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaropolk RC',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Yaropolk RC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSpeed = 0;
  bool _connectionStatus = false;
  String _connButtonLabel = "";

  Widget buildButton(Widget bt) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              fixedSize: const Size(100, 100),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 30),
            ),
            onPressed: () {},
            child: bt, //Text(txt),
          ),
        ],
      ),
    );
  }

  String getConnButtonLabel() {
    return (_connectionStatus == true) ? "Disconnect" : "Connect";
  }

  void connButtonPressed() {
    setState(() {
      _connectionStatus = !_connectionStatus;
    });
  }

  void pingButtonPressed() {}

  @override
  Widget build(BuildContext context) {
    var logWidget = const TextField(
      maxLines: 15,
    );

    var speedSlider = Slider(
      value: _currentSpeed,
      max: 10.0,
      divisions: 10,
      label: _currentSpeed.toString(),
      onChanged: (double value) {
        setState(() {
          _currentSpeed = value;
        });
      },
    );

    var upButton = buildButton(const Icon(Icons.north));
    var leftButton = buildButton(const Icon(Icons.west));
    var rightButton = buildButton(const Icon(Icons.east));
    var downButton = buildButton(const Icon(Icons.south));

    var connButton = TextButton(
        onPressed: connButtonPressed, child: Text(getConnButtonLabel()));
    var pingButton =
        TextButton(onPressed: pingButtonPressed, child: const Text("Ping"));

    var ctrlRow = Row(
      children: [connButton, pingButton],
    );

    var upButtonRow = Padding(
      padding: const EdgeInsets.symmetric(),
      child: upButton,
    );

    var leftRightButtonsRow = Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [leftButton, rightButton],
        ));

    var downButtonRow = Padding(
      padding: const EdgeInsets.symmetric(),
      child: downButton,
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ctrlRow,
          logWidget,
          speedSlider,
          upButtonRow,
          leftRightButtonsRow,
          downButtonRow
        ],
      )),
    );
  }
}
