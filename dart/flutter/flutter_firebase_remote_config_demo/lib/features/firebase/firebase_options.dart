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
    apiKey: 'AIzaSyDAUhVmD9MSyP3sRANtdgt7i_XxMM4TmBQ',
    appId: '1:598115471565:web:d40d1ac6cf920e5ef21984',
    messagingSenderId: '598115471565',
    projectId: 'fir-remote-config-demo-940e0',
    authDomain: 'fir-remote-config-demo-940e0.firebaseapp.com',
    storageBucket: 'fir-remote-config-demo-940e0.appspot.com',
    measurementId: 'G-EXDLS05D3J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtSZGMsgRluArNDCSeixC8TuZBWRYvZow',
    appId: '1:598115471565:android:0445387c8d417831f21984',
    messagingSenderId: '598115471565',
    projectId: 'fir-remote-config-demo-940e0',
    storageBucket: 'fir-remote-config-demo-940e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAG7a5UBkuxGZg4CC4rCZD-a4QORx0x-lY',
    appId: '1:598115471565:ios:5d06e096f0ac8a05f21984',
    messagingSenderId: '598115471565',
    projectId: 'fir-remote-config-demo-940e0',
    storageBucket: 'fir-remote-config-demo-940e0.appspot.com',
    iosClientId: '598115471565-no3ife2aaa9135q6g3pru5o4mpmo60ji.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFirebaseRemoteConfigDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAG7a5UBkuxGZg4CC4rCZD-a4QORx0x-lY',
    appId: '1:598115471565:ios:5d06e096f0ac8a05f21984',
    messagingSenderId: '598115471565',
    projectId: 'fir-remote-config-demo-940e0',
    storageBucket: 'fir-remote-config-demo-940e0.appspot.com',
    iosClientId: '598115471565-no3ife2aaa9135q6g3pru5o4mpmo60ji.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFirebaseRemoteConfigDemo',
  );
}
