import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDgkb6jrf-0K1M90b-pz2ZHZ51UHiEBjNk',
    authDomain: 'niroggram-238bd.firebaseapp.com',
    projectId: 'niroggram-238bd',
    storageBucket: 'niroggram-238bd.firebasestorage.app',
    messagingSenderId: '433369996153',
    appId: '1:433369996153:web:f82eb4d610880fd2a3eda8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgkb6jrf-0K1M90b-pz2ZHZ51UHiEBjNk',
    authDomain: 'niroggram-238bd.firebaseapp.com',
    projectId: 'niroggram-238bd',
    storageBucket: 'niroggram-238bd.firebasestorage.app',
    messagingSenderId: '433369996153',
    appId: '1:433369996153:web:f82eb4d610880fd2a3eda8',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgkb6jrf-0K1M90b-pz2ZHZ51UHiEBjNk',
    authDomain: 'niroggram-238bd.firebaseapp.com',
    projectId: 'niroggram-238bd',
    storageBucket: 'niroggram-238bd.firebasestorage.app',
    messagingSenderId: '433369996153',
    appId: '1:433369996153:web:f82eb4d610880fd2a3eda8',
  );
}
