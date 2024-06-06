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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCOS1niAaPK6pREkiho5gAY_GEqG1rTe-g',
    appId: '1:1080975283421:web:943621d64b1f2272e8f734',
    messagingSenderId: '1080975283421',
    projectId: 'pinglog-beta',
    authDomain: 'pinglog-beta.firebaseapp.com',
    storageBucket: 'pinglog-beta.appspot.com',
    measurementId: 'G-3YR5C2P3V8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPbWTZGxDEBkMtGzauCd7FZ4rKrhFfzbQ',
    appId: '1:1080975283421:android:c5801bd0fcf194d3e8f734',
    messagingSenderId: '1080975283421',
    projectId: 'pinglog-beta',
    storageBucket: 'pinglog-beta.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBdHG3X7U9RoZ3LiwhEF_EO6Xsy6bNjI1Q',
    appId: '1:1080975283421:ios:cee8fb9451a0baafe8f734',
    messagingSenderId: '1080975283421',
    projectId: 'pinglog-beta',
    storageBucket: 'pinglog-beta.appspot.com',
    iosClientId: '1080975283421-bk78mn077redtcdoka19kskvjs81fbot.apps.googleusercontent.com',
    iosBundleId: 'com.example.testProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBdHG3X7U9RoZ3LiwhEF_EO6Xsy6bNjI1Q',
    appId: '1:1080975283421:ios:cee8fb9451a0baafe8f734',
    messagingSenderId: '1080975283421',
    projectId: 'pinglog-beta',
    storageBucket: 'pinglog-beta.appspot.com',
    iosClientId: '1080975283421-bk78mn077redtcdoka19kskvjs81fbot.apps.googleusercontent.com',
    iosBundleId: 'com.example.testProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCOS1niAaPK6pREkiho5gAY_GEqG1rTe-g',
    appId: '1:1080975283421:web:943621d64b1f2272e8f734',
    messagingSenderId: '1080975283421',
    projectId: 'pinglog-beta',
    authDomain: 'pinglog-beta.firebaseapp.com',
    storageBucket: 'pinglog-beta.appspot.com',
    measurementId: 'G-3YR5C2P3V8',
  );

}