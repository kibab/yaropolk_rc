class FakeBluetoothEmitter {
  int _val = 0;
  bool _stopped = false;

  static Future<FakeBluetoothEmitter> toAddress(String address) async {
    await Future.delayed(const Duration(seconds: 1));
    return FakeBluetoothEmitter();
  }

  Stream<int> values() async* {
    while (!_stopped) {
      await Future.delayed(const Duration(seconds: 1));
      print("Yield!\n");
      yield _val++;
    }
  }

  void close() {
    _stopped = true;
  }
}
