import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:cloud_firestore/cloud_firestore.dart';
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
/// 


//saves notification setting to user
void saveReminderPreferences(String userId, Map<String, bool> days) {
  FirebaseFirestore.instance.collection('users').doc(userId).update({
    'reminderDays': days,
  });
}

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
    apiKey: 'AIzaSyCEBvFjyTDVE7FkjDBs7Umo7sokUHxgJ4c',
    appId: '1:722960252437:web:69037c1a9f5e9802bcd81c',
    messagingSenderId: '722960252437',
    projectId: 'getfit-comp4768',
    authDomain: 'getfit-comp4768.firebaseapp.com',
    storageBucket: 'getfit-comp4768.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJOV4AiLmdxALH9umAucERVghUHxyrZc8',
    appId: '1:722960252437:android:ffb1b8daf8e41ed0bcd81c',
    messagingSenderId: '722960252437',
    projectId: 'getfit-comp4768',
    storageBucket: 'getfit-comp4768.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRSl-44JHuCJXEHPqr6iOzELYomFKTvS0',
    appId: '1:722960252437:ios:a3397aab37415f26bcd81c',
    messagingSenderId: '722960252437',
    projectId: 'getfit-comp4768',
    storageBucket: 'getfit-comp4768.appspot.com',
    iosClientId:
        '722960252437-d1i8ucuivnt8qmbc4d6cpog3jbttggof.apps.googleusercontent.com',
    iosBundleId: 'com.example.getfit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRSl-44JHuCJXEHPqr6iOzELYomFKTvS0',
    appId: '1:722960252437:ios:d1e31a2dc76b7986bcd81c',
    messagingSenderId: '722960252437',
    projectId: 'getfit-comp4768',
    storageBucket: 'getfit-comp4768.appspot.com',
    iosClientId:
        '722960252437-4ec8k8fketpoinng253v6vmautlito99.apps.googleusercontent.com',
    iosBundleId: 'com.example.getfit.RunnerTests',
  );
}
