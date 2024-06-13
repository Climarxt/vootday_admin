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
    apiKey: 'AIzaSyCD_ehySwP-sdeeM5Z5SSYlprazSaIhDnA',
    appId: '1:920926023285:web:ed93fa55184c50e2e3d23c',
    messagingSenderId: '920926023285',
    projectId: 'bootdv2',
    authDomain: 'bootdv2.firebaseapp.com',
    databaseURL:
        'https://bootdv2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'bootdv2.appspot.com',
    measurementId: 'G-MVJ791NXR7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVGmOAjkoLSUXUogOyRYq7JudY_hBaD8I',
    appId: '1:920926023285:android:2238423a26698b83e3d23c',
    messagingSenderId: '920926023285',
    projectId: 'bootdv2',
    databaseURL:
        'https://bootdv2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'bootdv2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMGQuIZjr3oNgVVShxf_PKD7YKWm5WzaQ',
    appId: '1:920926023285:ios:125fab48ad176823e3d23c',
    messagingSenderId: '920926023285',
    projectId: 'bootdv2',
    databaseURL:
        'https://bootdv2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'bootdv2.appspot.com',
    iosBundleId: 'com.example.vootdayAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMGQuIZjr3oNgVVShxf_PKD7YKWm5WzaQ',
    appId: '1:920926023285:ios:05dcde5ad8f3a1a9e3d23c',
    messagingSenderId: '920926023285',
    projectId: 'bootdv2',
    databaseURL:
        'https://bootdv2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'bootdv2.appspot.com',
    iosBundleId: 'com.example.vootdayAdmin.RunnerTests',
  );
}
