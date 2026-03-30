import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBOYax1R86jh3BBXntWLJ8rLkcSkXrO5Mg',
    authDomain: 'madadgar-bf78f.firebaseapp.com',
    projectId: 'madadgar-bf78f',
    storageBucket: 'madadgar-bf78f.firebasestorage.app',
    messagingSenderId: '96976750490',
    appId: '1:96976750490:web:7512862e51da615256dc23',
  );
}
