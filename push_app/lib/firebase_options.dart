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
    apiKey: 'AIzaSyAewOOQvjAbpdFhklmei_2FVlQKfbi-BRU',
    appId: '1:787578162373:web:6174bd99f258f69d5034ac',
    messagingSenderId: '787578162373',
    projectId: 'flutter-push-fa727',
    authDomain: 'flutter-push-fa727.firebaseapp.com',
    storageBucket: 'flutter-push-fa727.appspot.com',
    measurementId: 'G-9F4JJ5678E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsEvmA7VjOe9VyDGtzNoei0cAFyVnTMEM',
    appId: '1:787578162373:android:60751bfa908263e25034ac',
    messagingSenderId: '787578162373',
    projectId: 'flutter-push-fa727',
    storageBucket: 'flutter-push-fa727.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnGEPtRS0R6VnSVmKdiIgfe57SwpS-iBw',
    appId: '1:787578162373:ios:7d16de25bc7a73c15034ac',
    messagingSenderId: '787578162373',
    projectId: 'flutter-push-fa727',
    storageBucket: 'flutter-push-fa727.appspot.com',
    androidClientId: '787578162373-frlu92nlt67tfrv7em78a03sbh5shidj.apps.googleusercontent.com',
    iosClientId: '787578162373-irfubpq80m8pch072as1ghodt4int9bv.apps.googleusercontent.com',
    iosBundleId: 'com.example.pushApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnGEPtRS0R6VnSVmKdiIgfe57SwpS-iBw',
    appId: '1:787578162373:ios:0a3ec45efa9cab475034ac',
    messagingSenderId: '787578162373',
    projectId: 'flutter-push-fa727',
    storageBucket: 'flutter-push-fa727.appspot.com',
    androidClientId: '787578162373-frlu92nlt67tfrv7em78a03sbh5shidj.apps.googleusercontent.com',
    iosClientId: '787578162373-1pn73ps09nqbn2r0rvn37vnc3cqkkt9k.apps.googleusercontent.com',
    iosBundleId: 'com.example.pushApp.RunnerTests',
  );
}