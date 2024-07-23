import 'package:flutter/material.dart';

class FlatTirePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Fix a Flat Tire'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/flat_tire.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildInstructionCard(
                  '1. Find a Safe Location:',
                  'Pull over to a safe location away from traffic.',
                ),
                _buildInstructionCard(
                  '2. Remove Hubcap or Wheel Cover:',
                  'Use a flathead screwdriver or a hubcap removal tool.',
                ),
                _buildInstructionCard(
                  '3. Loosen Lug Nuts:',
                  'Use a lug wrench to loosen, but don’t remove the lug nuts.',
                ),
                _buildInstructionCard(
                  '4. Lift the Vehicle:',
                  'Use a jack to lift the vehicle off the ground.',
                ),
                _buildInstructionCard(
                  '5. Remove the Flat Tire:',
                  'Remove the loosened lug nuts and take off the flat tire.',
                ),
                _buildInstructionCard(
                  '6. Install the Spare Tire:',
                  'Place the spare tire on the wheel hub and tighten the lug nuts.',
                ),
                _buildInstructionCard(
                  '7. Lower the Vehicle:',
                  'Carefully lower the vehicle back to the ground.',
                ),
                _buildInstructionCard(
                  '8. Replace the Hubcap or Wheel Cover:',
                  'Reattach the hubcap or wheel cover if applicable.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
