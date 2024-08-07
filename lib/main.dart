import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:garage_finder/pages/auth_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garage_finder/pages/map_pages.dart';
import 'package:garage_finder/pages/home_page.dart';
import 'package:garage_finder/pages/payments.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:garage_finder/pages/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.car_repair,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(height: 20.0),
            Text(
              'Garage Finder',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blue,
        nextScreen: AuthPage(),
        splashIconSize: 300.0,
      ),
    );
  }
}
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanic Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MapScreen(mechanicId: 'example_mechanic_id'),
    );
  }
}
//void mechanicId(StringCharacters)