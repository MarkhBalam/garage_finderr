import 'package:flutter/material.dart';

class RecentActivityPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => RecentActivityPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Activity'),
      ),
      body: Center(
        child: Text('This is the Recent Activity Page'),
      ),
    );
  }
}
