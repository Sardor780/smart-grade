import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for fuchsia.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDPxSRiJ9Zk8VZ1AlKvSxBYj6vn1stwoGc',
    appId: '1:98405079463:web:28b1b6fb4180a2f5eebe82',
    messagingSenderId: '98405079463',
    projectId: 'subject-fef29',
    authDomain: 'subject-fef29.firebaseapp.com',
    storageBucket: 'subject-fef29.firebasestorage.app',
    measurementId: 'G-B6L2L8QVYV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlUgPaAsJFAXLTiXp8khvabtgYUd3SLaQ',
    appId: '1:98405079463:android:edec5a576f1bb21beebe82',
    messagingSenderId: '98405079463',
    projectId: 'subject-fef29',
    storageBucket: 'subject-fef29.firebasestorage.app',
  );
}
