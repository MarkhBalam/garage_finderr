import 'package:flutter/material.dart';

class AirFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace an Air Filter'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/air_filter.jpg'), // Path to your background image
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
                  '1. Locate the Air Filter:',
                  'Find the air filter box under the hood.',
                ),
                _buildInstructionCard(
                  '2. Remove the Air Filter Box Cover:',
                  'Unscrew or unclamp the cover to access the filter.',
                ),
                _buildInstructionCard(
                  '3. Remove the Old Air Filter:',
                  'Take out the old filter and clean the compartment if necessary.',
                ),
                _buildInstructionCard(
                  '4. Install the New Air Filter:',
                  'Place the new filter into the compartment.',
                ),
                _buildInstructionCard(
                  '5. Reattach the Air Filter Box Cover:',
                  'Screw or clamp the cover back into place.',
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
