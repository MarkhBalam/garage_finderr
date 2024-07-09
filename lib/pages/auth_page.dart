import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_finder/pages/login_or_register.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'login_or_register.dart'; // Make sure to import LoginPage

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // is user logged in
          if (snapshot.hasData) {
            return HomePage();
          } else {
            // is user not logged in
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
