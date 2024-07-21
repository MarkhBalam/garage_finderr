import 'package:flutter/material.dart';

class RecentActivityPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => RecentActivityPage());
  }

  final List<Map<String, String>> recentActivities = [
    {
      'title': 'Requested Tow Service',
      'description':
          'Requested a tow service for a flat tire on July 20, 2024.',
      'timestamp': '2024-07-20 14:30'
    },
    {
      'title': 'Booked Garage Appointment',
      'description': 'Booked an appointment at XYZ Garage for oil change.',
      'timestamp': '2024-07-18 10:00'
    },
    {
      'title': 'Requested Breakdown Assistance',
      'description': 'Requested breakdown assistance for engine overheating.',
      'timestamp': '2024-07-15 08:45'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Recent Activity'),
        centerTitle: true,
        elevation: 5,
      ),
      body: ListView.builder(
        itemCount: recentActivities.length,
        itemBuilder: (context, index) {
          final activity = recentActivities[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'] ?? 'No title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    activity['description'] ?? 'No description',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        activity['timestamp'] ?? 'No timestamp',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
