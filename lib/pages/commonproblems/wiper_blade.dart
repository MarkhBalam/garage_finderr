import 'package:flutter/material.dart';

class WiperBladePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace Wiper Blades'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/wiper_blade.jpg'), // Path to your background image
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
                  '1. Lift the Wiper Blade Arm:',
                  'Pull the wiper blade arm away from the windshield.',
                ),
                _buildInstructionCard(
                  '2. Remove the Old Wiper Blade:',
                  'Press the release tab and slide the wiper blade off.',
                ),
                _buildInstructionCard(
                  '3. Attach the New Wiper Blade:',
                  'Slide the new blade onto the arm until it clicks into place.',
                ),
                _buildInstructionCard(
                  '4. Test the New Wiper Blade:',
                  'Turn on the wipers to ensure they work correctly.',
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
