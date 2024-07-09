import 'package:flutter/material.dart';
import 'package:garage_finder/pages/login_page.dart';
import 'package:garage_finder/pages/register_page.dart'; // Assuming you have a RegisterPage for the Registerpage() method

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // INITIALIZE SHOW LOGIN PAGE
  bool showLoginPage = true;

  // Toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showLoginPage
            ? LoginPage(
                onTap: togglePages) // Pass the togglePages method to LoginPage
            : RegisterPage(
                onTap:
                    togglePages), // Pass the togglePages method to RegisterPage
      ),
    );
  }
}
