import 'package:flutter/material.dart';

class HeadlightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace Headlights'),
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
                  '1. Open the Hood:',
                  'Locate the headlight assembly under the hood.',
                ),
                _buildInstructionCard(
                  '2. Remove the Headlight Assembly:',
                  'Unscrew or unclamp the headlight assembly from the vehicle.',
                ),
                _buildInstructionCard(
                  '3. Remove the Old Headlight Bulb:',
                  'Twist the bulb out of the socket.',
                ),
                _buildInstructionCard(
                  '4. Insert the New Headlight Bulb:',
                  'Place the new bulb into the socket and twist to secure.',
                ),
                _buildInstructionCard(
                  '5. Reinstall the Headlight Assembly:',
                  'Reattach the headlight assembly to the vehicle.',
                ),
                _buildInstructionCard(
                  '6. Test the Headlights:',
                  'Turn on the headlights to make sure they are working.',
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
