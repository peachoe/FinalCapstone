// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJCXCC4PN2GOGDgIAHWCzCtkLuUX2tSaY',
    appId: '1:554798596010:web:496004db8e70e3d1bd75d3',
    messagingSenderId: '554798596010',
    projectId: 'finalcapstone-425405',
    authDomain: 'finalcapstone-425405.firebaseapp.com',
    databaseURL: 'https://finalcapstone-425405-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'finalcapstone-425405.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDECt-QBq0zf7xSDH3hTm62m6FY9-E-QdE',
    appId: '1:554798596010:android:5a7bd8984cb9656ebd75d3',
    messagingSenderId: '554798596010',
    projectId: 'finalcapstone-425405',
    databaseURL: 'https://finalcapstone-425405-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'finalcapstone-425405.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDJCXCC4PN2GOGDgIAHWCzCtkLuUX2tSaY',
    appId: '1:554798596010:web:35c49c7618f22a38bd75d3',
    messagingSenderId: '554798596010',
    projectId: 'finalcapstone-425405',
    authDomain: 'finalcapstone-425405.firebaseapp.com',
    databaseURL: 'https://finalcapstone-425405-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'finalcapstone-425405.appspot.com',
  );
}
