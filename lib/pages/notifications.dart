import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Garage Finder!'),
        ),
        body: NotificationPage(),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _streamSubscription;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();

    // Request permission to receive notifications
    FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );

    // Initialize the Firebase messaging instance
    _firebaseMessaging = FirebaseMessaging.instance;

    // Listen for incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      setState(() {
        notifications.add({
          'title': message.notification?.title ?? 'Notification',
          'body': message.notification?.body ?? 'Body',
          'date': DateTime.now(),
        });
      });

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Listen for notification messages when the app is in the background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is closed, then opened by tapping the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    setState(() {
      notifications.add({
        'title': message.notification?.title ?? 'Notification',
        'body': message.notification?.body ?? 'Body',
        'date': DateTime.now(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(notifications[index]['title']),
              subtitle: Text(
                notifications[index]['body'] +
                    '\n\nSent on: ${notifications[index]['date'].toString()}',
              ),
            ),
          );
        },
      ),
    );
  }
}
