import 'package:flutter/material.dart';
import 'package:garage_finder/pages/login_page.dart';
import 'package:garage_finder/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

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
            ? LoginPage(onTap: togglePages)
            : RegisterPage(onTap: togglePages),
      ),
    );
  }
}
