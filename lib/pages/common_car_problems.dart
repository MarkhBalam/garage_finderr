import 'package:flutter/material.dart';
import 'package:garage_finder/pages/commonproblems/flat_tire.dart';
import 'package:garage_finder/pages/commonproblems/dead_battery.dart';
import 'package:garage_finder/pages/commonproblems/air_filter.dart';
import 'package:garage_finder/pages/commonproblems/wiper_blade.dart';
import 'package:garage_finder/pages/commonproblems/fluids.dart';
import 'package:garage_finder/pages/commonproblems/headlight.dart';
import 'package:garage_finder/pages/commonproblems/tirepressure.dart';
import 'package:garage_finder/pages/commonproblems/fusepage.dart';
import 'package:garage_finder/pages/commonproblems/headlight_adjustment.dart';

class CommonCarProblemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Common Car Problems'),
        backgroundColor: Colors.blue, // AppBar color set to blue
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/common.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          ListView(
            padding: EdgeInsets.all(8.0), // Added padding for better visuals
            children: [
              ProblemTile(
                title: 'Flat Tire',
                subtitle: 'Instructions for changing a flat tire.',
                onTap: () => _navigateTo(context, FlatTirePage()),
              ),
              ProblemTile(
                title: 'Dead Battery',
                subtitle: 'Instructions for jump-starting a car.',
                onTap: () => _navigateTo(context, DeadBatteryPage()),
              ),
              ProblemTile(
                title: 'Replace Air Filter',
                subtitle: 'Instructions for replacing the air filter.',
                onTap: () => _navigateTo(context, AirFilterPage()),
              ),
              ProblemTile(
                title: 'Wiper Blade Replacement',
                subtitle: 'Instructions for replacing wiper blades.',
                onTap: () => _navigateTo(context, WiperBladePage()),
              ),
              ProblemTile(
                title: 'Check and Top Up Fluids',
                subtitle:
                    'Instructions for checking and topping up car fluids.',
                onTap: () => _navigateTo(context, FluidsPage()),
              ),
              ProblemTile(
                title: 'Headlight Replacement',
                subtitle: 'Instructions for replacing headlights.',
                onTap: () => _navigateTo(context, HeadlightPage()),
              ),
              ProblemTile(
                title: 'Check Tire Pressure',
                subtitle:
                    'Instructions for checking and adjusting tire pressure.',
                onTap: () => _navigateTo(context, TirePressurePage()),
              ),
              ProblemTile(
                title: 'Replace Fuse',
                subtitle: 'Instructions for replacing a blown fuse.',
                onTap: () => _navigateTo(context, FusePage()),
              ),
              ProblemTile(
                title: 'Adjust Headlights',
                subtitle: 'Instructions for adjusting your headlights.',
                onTap: () => _navigateTo(context, HeadlightsAdjustmentPage()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class ProblemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProblemTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0), // Margin between tiles
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3.0), // Thick border
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        color: Colors.white.withOpacity(0.9), // Slightly transparent background
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        leading:
            Icon(Icons.build, color: Colors.blue), // Build icon for problems
        onTap: onTap,
      ),
    );
  }
}
