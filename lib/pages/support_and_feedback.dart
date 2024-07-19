import 'package:flutter/material.dart';

class SupportAndFeedbackPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => SupportAndFeedbackPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Support and Feedback'),
      ),
      body: Center(
        child: Text('This is the Support and Feedback Page'),
      ),
    );
  }
}
