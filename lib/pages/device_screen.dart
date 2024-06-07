import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';



class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  DeviceScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device: ${device.platformName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Device ID: ${device.remoteId}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await device.disconnect();
                Navigator.of(context).pop();
              },
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
