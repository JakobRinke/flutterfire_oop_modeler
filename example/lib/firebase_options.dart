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
    apiKey: 'AIzaSyCJK_7iFje-Gu4q1lOKpdnhQG4zfllqZIQ',
    appId: '1:624584796496:web:84e1d8f2dba919e7056455',
    messagingSenderId: '624584796496',
    projectId: 'bmi-calculator-e3b65',
    authDomain: 'bmi-calculator-e3b65.firebaseapp.com',
    databaseURL: 'https://bmi-calculator-e3b65-default-rtdb.firebaseio.com',
    storageBucket: 'bmi-calculator-e3b65.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjkKkTLJrxyBW5K-w_W_HSZx-7U-JxItM',
    appId: '1:624584796496:android:7e1f67781aeafd6a056455',
    messagingSenderId: '624584796496',
    projectId: 'bmi-calculator-e3b65',
    databaseURL: 'https://bmi-calculator-e3b65-default-rtdb.firebaseio.com',
    storageBucket: 'bmi-calculator-e3b65.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADO9cUIQI3zF7RWFjfBdmKTJvKuXfFdZQ',
    appId: '1:624584796496:ios:e9cfd9de7304864e056455',
    messagingSenderId: '624584796496',
    projectId: 'bmi-calculator-e3b65',
    databaseURL: 'https://bmi-calculator-e3b65-default-rtdb.firebaseio.com',
    storageBucket: 'bmi-calculator-e3b65.appspot.com',
    iosBundleId: 'com.example.example',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADO9cUIQI3zF7RWFjfBdmKTJvKuXfFdZQ',
    appId: '1:624584796496:ios:976a392fb8c9d776056455',
    messagingSenderId: '624584796496',
    projectId: 'bmi-calculator-e3b65',
    databaseURL: 'https://bmi-calculator-e3b65-default-rtdb.firebaseio.com',
    storageBucket: 'bmi-calculator-e3b65.appspot.com',
    iosBundleId: 'com.example.example.RunnerTests',
  );
}