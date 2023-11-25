// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBMdktfzHcIq-6dh2QlrsW8BD-GCcRLsWc',
    appId: '1:503073606477:web:7c6321fa00b87bf351c504',
    messagingSenderId: '503073606477',
    projectId: 'unitapp-e732a',
    authDomain: 'unitapp-e732a.firebaseapp.com',
    storageBucket: 'unitapp-e732a.appspot.com',
    measurementId: 'G-RFDH27W6MD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYq-rTDyaq4nIxSS7fpYEJfdnXXqW-zjY',
    appId: '1:503073606477:android:cab051fcb58e78f651c504',
    messagingSenderId: '503073606477',
    projectId: 'unitapp-e732a',
    storageBucket: 'unitapp-e732a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2-JTVPAdbM6ftOSITitpz3x6ajxd55ls',
    appId: '1:503073606477:ios:32b3aeb71f4ade0151c504',
    messagingSenderId: '503073606477',
    projectId: 'unitapp-e732a',
    storageBucket: 'unitapp-e732a.appspot.com',
    iosBundleId: 'com.example.unitapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2-JTVPAdbM6ftOSITitpz3x6ajxd55ls',
    appId: '1:503073606477:ios:d668c68dc69d6e0a51c504',
    messagingSenderId: '503073606477',
    projectId: 'unitapp-e732a',
    storageBucket: 'unitapp-e732a.appspot.com',
    iosBundleId: 'com.example.unitapp.RunnerTests',
  );
}
