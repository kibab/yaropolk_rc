import 'package:yaropolk/fakebt.dart';

enum ConnectionState { disconnected, connecting, connected }

class Yaropolk {
  // ignore: constant_identifier_names
  static const String BT_ADDRESS = "00:00:00:00:00:00";
  int _currentSpeed = 0;
  List<String> logs = [];
  ConnectionState _connState = ConnectionState.disconnected;
  //BluetoothConnection? _connection;
  FakeBluetoothEmitter? _connection;

  void connect(void Function(int data) handler) async {
    try {
      _connState = ConnectionState.connecting;
      _connection = await FakeBluetoothEmitter.toAddress(BT_ADDRESS);
      print('Connected to the device');
      _connState = ConnectionState.connected;
    } catch (exception) {
      _connState = ConnectionState.disconnected;
      _connection = null;
      print('Cannot connect, exception occured');
    }

    /* Connection is here! Set a handler for reading from the log */
    _connection!.values().listen(handler);
  }

  void disconnect() {
    if (_connState == ConnectionState.disconnected) return;
    _connection!.close();
    _connState = ConnectionState.disconnected;
  }

  void _sendCode(String code) {
    var sendStr = code + "\n";
    if (_connState != ConnectionState.connected) return;
    print("Sending code " + sendStr + "\n");
    //_connection!.output.add(ascii.encode(sendStr));
  }

  void moveForward() {
    _sendCode("MF");
  }

  void moveBack() {
    _sendCode("MB");
  }

  void rotateLeft() {
    _sendCode("ML");
  }

  void rotateRight() {
    _sendCode("MR");
  }

  int getSpeed() {
    return _currentSpeed;
  }

  void setSpeed(int speed) {
    _currentSpeed = speed;
    _sendCode("S" + speed.toString());
  }

  void ping() {
    _sendCode("P_");
  }
}
