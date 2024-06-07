import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late Stream<DiscoveredDevice> _scanStream;
  List<DiscoveredDevice> _scanResults = [];
  late StreamSubscription<ConnectionStateUpdate> _connection;
  List<DiscoveredDevice> connectedDevices = [];
  bool isScanning = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _connection.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      isScanning = true;
      _scanResults.clear();
    });

    _scanStream = _ble.scanForDevices(withServices: []);
    _scanStream.listen((device) {
      setState(() {
        _scanResults.add(device);
      });
    }, onError: (error) {
      setState(() {
        isScanning = false;
      });
    }, onDone: () {
      setState(() {
        isScanning = false;
      });
    });
  }

  Future<void> _stopScan() async {
    setState(() {
      isScanning = false;
    });
    await _scanStream.listen(null).cancel();
  }

  void _connectToDevice(DiscoveredDevice device) {
    final connection = _ble.connectToDevice(id: device.id);
    _connection = connection.listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        setState(() {
          connectedDevices.add(device);
        });
      } else if (connectionState.connectionState == DeviceConnectionState.disconnected) {
        setState(() {
          connectedDevices.remove(device);
        });
      }
    });
  }

  void _disconnectFromDevice(DiscoveredDevice device) async {
    await _ble.clearGattCache(device.id); // 적절한 메서드 사용
    setState(() {
      connectedDevices.remove(device);
    });
  }

  void playAudio() async {
    String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
    await audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('블루투스 기기', style: TextStyle(color: Colors.teal)),
        backgroundColor: Color(0xFFE5FEFF),
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: Container(
        color: Color(0xFFE5FEFF),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: _connectedDevices(),
            ),
            Flexible(
              flex: 4,
              child: _scanningDevices(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: playAudio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                ),
                child: Text('Play Audio'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectedDevices() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: const Text(
            '연결된 기기',
            style: TextStyle(
                color: Colors.teal, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: connectedDevices.length,
            itemBuilder: (context, index) {
              var connectedDevice = connectedDevices[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlue[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bluetooth),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          connectedDevice.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID : [${connectedDevice.id}]',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _disconnectFromDevice(connectedDevice),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Disconnect'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _scanningDevices() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isScanning ? null : _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: isScanning ? Colors.grey : Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: Text(isScanning ? 'Scanning...' : 'Scan'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _stopScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Stop!'),
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: const Text(
            '스캔된 기기',
            style: TextStyle(
                color: Colors.teal, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _stopScan().then((_) => _startScan()),
            child: ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (BuildContext context, int index) {
                var scanResult = _scanResults[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bluetooth),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            scanResult.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID : [${scanResult.id}]',
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => _connectToDevice(scanResult),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Connect'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DeviceScreen extends StatelessWidget {
  final DiscoveredDevice device;

  DeviceScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device: ${device.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Device ID: ${device.id}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FlutterReactiveBle().clearGattCache(device.id); // 적절한 메서드 사용
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
