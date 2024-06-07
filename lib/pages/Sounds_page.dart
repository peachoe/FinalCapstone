<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'dart:convert'; // utf8을 사용하기 위해 import
//import 'package:smarthomeui/pages/device_screen.dart'; // DeviceScreen 페이지를 임포트
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:vibration/vibration.dart';
//import 'dart:typed_data';


class SoundsPage extends StatefulWidget {
  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  List<BluetoothDevice> connectedDevices = [];
  bool isScanning = false;
  List<ScanResult> scanResults = [];
  late Interpreter _interpreter;
  bool isModelLoaded = false;



  @override
  void initState() {
    super.initState();
    _loadModel();
    getConnectedDevice();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('converted_model.tflite');
      setState(() {
        isModelLoaded = true;
      });
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  void getConnectedDevice() async {
    connectedDevices = await FlutterBluePlus.connectedDevices;
    setState(() {});
  }

  void startScan() {
    setState(() {
      isScanning = true;
      scanResults.clear();
    });
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
  }

  Future<void> stopScan() async {
    setState(() {
      isScanning = false;
    });
    await FlutterBluePlus.stopScan();
  }


  void _predictSound(List<int> input) {
    if (!isModelLoaded) return;

    // Preprocess input data
    List<double> inputAsFloat = input.map((e) => e / 255.0).toList();

    // Run inference
    var output = List<double>.filled(2, 0);
    _interpreter.run([inputAsFloat], [output]);

    // Postprocess output data
    var isCrying = output[0] > output[1];

    if (isCrying) {
      // 울음소리 감지
      print('Crying detected');
      Vibration.vibrate(pattern: [0, 500, 1000, 500, 1000]); // 진동 패턴
      setState(() {
        // 화면 LED 변화를 위해 상태 업데이트
      });
    } else {
      // 울음소리 감지되지 않음
      print('No crying detected');
      setState(() {
        // 상태 업데이트
      });
    }
  }

  void _handleCharacteristicValue(BluetoothCharacteristic characteristic) {
    characteristic.lastValueStream.listen((value) {
      _predictSound(value);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Screen'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: ConnectedDevices(),
          ),
          Flexible(
            flex: 4,
            child: ScanningDevices(),
          ),
        ],
      ),
    );
  }

  Widget ConnectedDevices() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Connected Devices',
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w700),
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
                          connectedDevice.platformName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID : [${connectedDevice.remoteId.toString()}]',
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
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(Colors.lightBlue[50]),
                          ),
                          onPressed: () {
                            connectedDevice.disconnect();
                            setState(() {
                              connectedDevices.remove(connectedDevice);
                            });
                          },
                          child: const Text('Disconnect'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Colors.orangeAccent[700]),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DeviceScreen(device: connectedDevice)),
                            );
                          },
                          child: const Text('Device..'),
                        )
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

  Widget ScanningDevices() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: isScanning ? null : startScan,
              child: Text(isScanning ? 'Scanning...' : 'Scan'),
            ),
            ElevatedButton(
              onPressed: stopScan,
              child: Text('Stop!'),
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Scanning Devices',
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => stopScan().then((_) => startScan()),
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (BuildContext context, int index) {
                var scanResult = scanResults[index];
                if (scanResult.device.platformName.isNotEmpty) {
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
                              scanResult.device.platformName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID : [${scanResult.device.remoteId.toString()}]',
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
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Colors.lightBlue[50]),
                              foregroundColor:
                              WidgetStateProperty.all(Colors.black)),
                          onPressed: () async {
                            await scanResult.device.connect();
                            setState(() {
                              scanResults.remove(scanResult);
                              connectedDevices.add(scanResult.device);
                            });
                            List<BluetoothService> services = await scanResult.device.discoverServices();
                            services.forEach((service) {
                              service.characteristics.forEach((characteristic) {
                                if (characteristic.properties.notify) {
                                  _handleCharacteristicValue(characteristic);
                                }
                              });
                            });
                          },
                          child: const Text('Connect'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

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
=======
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// //import 'dart:convert'; // utf8을 사용하기 위해 import
//
// class SoundsPage extends StatefulWidget {
//   @override
//   _SoundsPageState createState() => _SoundsPageState();
// }
//
// class _SoundsPageState extends State<SoundsPage> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   List<BluetoothDevice> connectedDevices = [];
//   bool isScanning = false;
//   List<ScanResult> scanResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // TODO: Connect to previously connected device (if any)
//     getConnectedDevice();
//   }
//
//   void getConnectedDevice() async {
//     connectedDevices = await flutterBlue.connectedDevices;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bluetooth Screen'),
//       ),
//       body: Column(
//         children: [
//           Flexible(
//             flex: 1,
//             child: ConnectedDevices(),
//           ),
//           Flexible(
//             flex: 4,
//             child: ScanningDevices(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget ConnectedDevices() {
//     return Column(
//       children: [
//         Container(
//           alignment: Alignment.centerLeft,
//           child: const Text(
//             'Connected Devices',
//             style: TextStyle(
//                 color: Colors.Blue[300], fontSize: 18, fontWeight: FontWeight.w700),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: connectedDevices.length,
//             itemBuilder: (context, index) {
//               var connectedDevice = connectedDevices[index];
//               return Container(
//                 margin:
//                 const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//                 height: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.lightBlue[100],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.bluetooth),
//                     const SizedBox(width: 8),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           connectedDevice!.name,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'ID : [${connectedDevice!.id.toString()}]',
//                           style: const TextStyle(
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     Column(
//                       children: [
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor:
//                             MaterialStateProperty.all(Colors.lightBlue[50]),
//                           ),
//                           onPressed: () {
//                             // TODO: Connect to selected device
//                             print('ID [ ${connectedDevice!.id}]');
//                             print('Name [ ${connectedDevice!.name}]');
//                             connectedDevice!.disconnect();
//                             setState(() {
//                               connectedDevices.remove(connectedDevice);
//                             });
//                           },
//                           child: const Text('disConnect'),
//                         ),
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(
//                                 Colors.orangeAccent[700]),
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       DeviceScreen(device: connectedDevice)),
//                             );
//                           },
//                           child: const Text('Device..'),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget ScanningDevices() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             ElevatedButton(
//               onPressed: isScanning ? null : startScan,
//               child: Text(isScanning ? 'Scanning...' : 'Scan'),
//             ),
//             ElevatedButton(
//               onPressed: stopScan,
//               child: Text('Stop!'),
//             ),
//           ],
//         ),
//         Container(
//           alignment: Alignment.centerLeft,
//           child: const Text(
//             'Scanning Devices',
//             style: TextStyle(
//                 color: Colors.Blue[300], fontSize: 18, fontWeight: FontWeight.w700),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: () => stopScan().then((_) => startScan()),
//             child: ListView.builder(
//               itemCount: scanResults.length,
//               itemBuilder: (BuildContext context, int index) {
//                 var scanResult = scanResults[index];
//                 if (scanResult.device.name.isNotEmpty) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 5.0, vertical: 5.0),
//                     height: 100,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.grey[200],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.bluetooth),
//                         const SizedBox(width: 8),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               scanResult.device.name,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'ID : [${scanResult.device.id.toString()}]',
//                               style: const TextStyle(
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         ElevatedButton(
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(
//                                   Colors.lightBlue[50]),
//                               foregroundColor:
//                               MaterialStateProperty.all(Colors.black)),
//                           onPressed: () {
//                             // TODO: Connect to selected device
//                             scanResult.device.connect();
//                             print('ID [ ${scanResult.device.id}]');
//                             print('Name [ ${scanResult.device.name}]');
//
//                             setState(() {
//                               scanResults.remove(scanResult.device);
//                               connectedDevices.add(scanResult.device);
//                             });
//                           },
//                           child: const Text('Connect'),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void startScan() async {
//     setState(() {
//       isScanning = true;
//       scanResults.clear();
//     });
//     try {
//       flutterBlue.scan().listen((scanResult) {
//         setState(() {
//           scanResults.add(scanResult);
//         });
//       });
//     } catch (e) {
//       print('error : ${e.toString()}');
//     }
//   }
//
//   Future<void> stopScan() async {
//     setState(() {
//       isScanning = false;
//     });
//     await flutterBlue.stopScan();
//   }
// }
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
