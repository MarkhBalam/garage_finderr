import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => ContactUsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Contact Us'),
      ),
      body: Center(
        child: Text('This is the Contact Us Page'),
      ),
    );
  }
}
