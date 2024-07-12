import 'package:flutter/material.dart';
import 'package:garage_finder/pages/home_page.dart';

class BreakdownAssistancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakdown Assistance'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Need Breakdown Assistance?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We are here to help you. Choose from the options below:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            QuickAccessButton(
              icon: Icons.local_taxi,
              label: 'Request a Tow Truck',
              onPressed: () {
                // Navigate to Request Tow Truck page
              },
            ),
            SizedBox(height: 10),
            QuickAccessButton(
              icon: Icons.phone,
              label: 'Contact Breakdown Services',
              onPressed: () {
                // Call breakdown services
              },
            ),
            SizedBox(height: 10),
            QuickAccessButton(
              icon: Icons.map,
              label: 'View Nearby Towing Services',
              onPressed: () {
                // Navigate to Nearby Towing Services page
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(icon, size: 38, color: Colors.blue),
                onPressed: onPressed,
              ),
            ),
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
