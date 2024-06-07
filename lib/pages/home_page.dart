import 'package:flutter/material.dart';
import 'package:smarthomeui/util/smart_device_box.dart'; // SmartDeviceBox 파일을 import 합니다
import 'package:smarthomeui/util/menu_bar.dart'; // CustomMenuBar 파일을 import 합니다
import 'package:smarthomeui/pages/camerastream.dart'; // CameraStreamPage 파일을 import 합니다
<<<<<<< HEAD
import 'package:smarthomeui/pages/audio_devices_page.dart'; //
import 'package:smarthomeui/pages/chatgpt_page.dart'; // ChatGPTPage 파일을 import 합니다
import 'package:smarthomeui/pages/Sounds_page.dart'; // SoundsPage 파일을 import 합니다
=======
import 'package:smarthomeui/pages/talk_page.dart'; // TalkPage 파일을 import 합니다
import 'package:smarthomeui/pages/chatgpt_page.dart'; // ChatGPTPage 파일을 import 합니다
//import 'package:smarthomeui/pages/Sounds_page.dart'; // SoundsPage 파일을 import 합니다
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Scaffold key 정의

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus, targetPage ]
    ["카메라", "lib/icons/videocamera.png", false, CameraStreamPage()],
    ["소리", "lib/icons/babycrying.png", false, SoundsPage()],
<<<<<<< HEAD
    ["블루투스", "lib/icons/bluetooth_icon.png", false, BluetoothPage()],
    ["TTS소통", "lib/icons/talk.png", false, ChatGPTPage()],
=======
    ["말하기", "lib/icons/speak.png", false, TalkPage()],
    ["AI챗봇", "lib/icons/chatgpt.png", false, ChatGPTPage()],
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Scaffold key 설정
      backgroundColor: const Color(0xFFE5FEFF), // 배경 색상을 #E5FEFF로 설정
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5FEFF),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'lib/icons/menu.png',
            height: 45,
            color: Colors.grey[800],
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Drawer 열기
          },
        ),
      ),
      drawer: CustomMenuBar(), // CustomMenuBar 사용
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "행복한 우리 집",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Image.asset(
                    'lib/icons/logo_text2.png',
                    width: 150, // 필요에 따라 이미지 크기를 조정
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 25),

            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "기능",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey.shade800),
              ),
            ),
            const SizedBox(height: 10),

            // grid
            GridView.builder(
              shrinkWrap: true,
              itemCount: mySmartDevices.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.3,
              ),
              itemBuilder: (context, index) {
                return SmartDeviceBox(
                  smartDeviceName: mySmartDevices[index][0],
                  iconPath: mySmartDevices[index][1],
                  powerOn: mySmartDevices[index][2],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mySmartDevices[index][3],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

<<<<<<< HEAD
=======

class SoundsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crying'),
      ),
      body: Center(
        child: Text('Sounds Page'),
      ),
    );
  }
}
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
