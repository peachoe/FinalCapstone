import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthomeui/util/user_provider.dart';
import 'package:smarthomeui/util/user.dart';
import 'package:smarthomeui/pages/camerastream.dart'; // CameraStreamPage 파일을 import 합니다
import 'package:smarthomeui/pages/viewer_page.dart';  // 새로 추가한 페이지를 import

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Role'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                userProvider.setUser(User(id: '1', name: 'Camera User'));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CameraStreamPage()),
                );
              },
              child: Text('Camera Mode'),
            ),
            ElevatedButton(
              onPressed: () {
                userProvider.setUser(User(id: '2', name: 'Viewer User'));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ViewerPage()),
                );
              },
              child: Text('Viewer Mode'),
            ),
          ],
        ),
      ),
    );
  }
}