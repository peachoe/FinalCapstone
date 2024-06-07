import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthomeui/pages/home_page.dart';
import 'package:smarthomeui/util/user_provider.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
=======


void main() {
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(), // 애플리케이션 시작 시 로그인 페이지를 표시합니다.
<<<<<<< HEAD
      ),
    );
  }
}
=======
    ),
    );
  }
}
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
