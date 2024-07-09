import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyACDsQEGGM_SWp3xHWQuQtUMOlEoQGUqWg',
      appId: '1:716594575799:web:b79dff8ec5799206a99032',
      messagingSenderId: '716594575799',
      projectId: 'garage-finder-fb405',
      authDomain: 'garage-finder-fb405.firebaseapp.com',
      storageBucket: 'garage-finder-fb405.appspot.com',
      databaseURL:
          'https://garage-finder-fb405-default-rtdb.europe-west1.firebasedatabase.app',
      measurementId: '', // Optional: Add your measurement ID for web analytics
    );
  }
}
