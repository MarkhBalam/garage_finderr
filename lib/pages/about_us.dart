import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => AboutUsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('About Us'),
      ),
      body: Center(
        child: Text('This is the About Us Page'),
      ),
    );
  }
}
