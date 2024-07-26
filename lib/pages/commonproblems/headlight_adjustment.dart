import 'package:flutter/material.dart';

class HeadlightsAdjustmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Adjust Headlights'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/headlight1.jpg'), // Path to your background image
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
                  '1. Park on a Level Surface:',
                  'Find a flat and level surface to adjust your headlights.',
                ),
                _buildInstructionCard(
                  '2. Position the Car:',
                  'Park the car facing a wall or garage door about 10-15 feet away.',
                ),
                _buildInstructionCard(
                  '3. Check Headlight Alignment:',
                  'Check the beam pattern on the wall and see if it needs adjustment.',
                ),
                _buildInstructionCard(
                  '4. Adjust the Headlights:',
                  'Use the adjustment screws to align the headlights properly.',
                ),
                _buildInstructionCard(
                  '5. Test the Headlights:',
                  'Turn on the headlights and check the alignment.',
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
