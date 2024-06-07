import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import 'package:provider/provider.dart';
//import 'package:smarthomeui/util/user_provider.dart';
//import 'package:http/http.dart' as http;
//import 'package:flutter_webrtc/flutter_webrtc.dart';
//import 'dart:convert';


class CameraStreamPage extends StatefulWidget {
  @override
  _CameraStreamPageState createState() => _CameraStreamPageState();
}

class _CameraStreamPageState extends State<CameraStreamPage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라 초기화
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 사용 가능한 카메라 목록 가져오기
    _cameras = await availableCameras();
    // 후면 카메라를 선택하여 컨트롤러 초기화
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    // 컨트롤러 초기화
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Stream'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 카메라가 초기화되었으면 카메라 미리보기 표시
            return CameraPreview(_controller);
          } else {
            // 그렇지 않으면 로딩 표시
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}