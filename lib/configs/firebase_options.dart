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
    apiKey: 'AIzaSyBINsK6iIcIu_e3Tm4HRglg3nmvjrgy-zM',
    appId: '1:121132222404:web:eef6ccd1145e16904e0691',
    messagingSenderId: '121132222404',
    projectId: 'upfin-6524b',
    authDomain: 'upfin-6524b.firebaseapp.com',
    databaseURL: 'https://upfin-6524b-default-rtdb.firebaseio.com',
    storageBucket: 'upfin-6524b.appspot.com',
    measurementId: 'G-4SL4681NTR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyBc-0zaE3Acl3I9CjqA7vhIVT665T_q8',
    appId: '1:121132222404:android:4907f093c687294e4e0691',
    messagingSenderId: '121132222404',
    projectId: 'upfin-6524b',
    databaseURL: 'https://upfin-6524b-default-rtdb.firebaseio.com',
    storageBucket: 'upfin-6524b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsZMz4klE7uxPeKdSFmotSL64WBXobSCk',
    appId: '1:121132222404:ios:ca637a6877d4fc834e0691',
    messagingSenderId: '121132222404',
    projectId: 'upfin-6524b',
    databaseURL: 'https://upfin-6524b-default-rtdb.firebaseio.com',
    storageBucket: 'upfin-6524b.appspot.com',
    androidClientId: '121132222404-tdugpjfo3fr1rhm85qohkal6o6cjmvf4.apps.googleusercontent.com',
    iosClientId: '121132222404-is98fn90r7rsqgd59s3c8snehlj3rg5o.apps.googleusercontent.com',
    iosBundleId: 'com.ysmeta.upfinai',
  );
}
