import 'package:flutter/material.dart';

class MechanicRequestsPage extends StatelessWidget {
  const MechanicRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic Requests'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'List of Mechanic Requests',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
