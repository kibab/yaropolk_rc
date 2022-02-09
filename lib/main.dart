import 'package:flutter/material.dart';
import 'package:yaropolk/yaropolk.dart';

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
  bool _needScroll = false;

  final _logScrollControl = ScrollController();
  final List<String> _log = ["one", "two", "three"];
  final Yaropolk _robot = Yaropolk();

  Widget buildButton(Widget bt, void Function() handler) {
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
            onPressed: handler,
            child: bt,
          ),
        ],
      ),
    );
  }

  String getConnButtonLabel() {
    return _connectionStatus ? "Disconnect" : "Connect";
  }

  void _onDataArrived(int data) {
    print("Data arrived in UI!\n");
    //_newLogStr = data.toString() + "\n";
    setState(() {
      _log.add(data.toString() + "\n");
      _needScroll = true;
      //_logController.text += data.toString() + "\n";
    });
  }

  void connButtonPressed() {
    if (_connectionStatus == false) {
      _robot.connect(_onDataArrived);
    } else {
      _robot.disconnect();
    }
    setState(() {
      _connectionStatus = !_connectionStatus;
    });
  }

  void pingButtonPressed() {
    _robot.ping();
  }

  _scrollLogToBottom() {
    if (_needScroll) {
      _logScrollControl.jumpTo(_logScrollControl.position.maxScrollExtent);
      _needScroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollLogToBottom());

    var logWidgetList = ListView.builder(
      itemCount: _log.length,
      controller: _logScrollControl,
      itemBuilder: (context, index) => SizedBox(
          height: 20,
          child: Text(
            "Log line #" + _log[index].toString(),
          )),
    );

    var logWidget = SizedBox(
      height: 300,
      child: logWidgetList,
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

    var upButton =
        buildButton(const Icon(Icons.north), () => {_robot.moveForward()});
    var leftButton =
        buildButton(const Icon(Icons.west), () => {_robot.rotateLeft()});
    var rightButton =
        buildButton(const Icon(Icons.east), () => {_robot.rotateRight()});
    var downButton =
        buildButton(const Icon(Icons.south), () => {_robot.moveBack()});

    var connButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton(
            onPressed: connButtonPressed, child: Text(getConnButtonLabel())));
    var pingButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton(
            onPressed: pingButtonPressed, child: const Text("Ping")));

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
