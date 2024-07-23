import 'package:flutter/material.dart';

class DeadBatteryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Jump-Start a Dead Battery'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/dead_battery.jpg'), // Path to your background image
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
                  '1. Position the Cars:',
                  'Park a working car close to the car with the dead battery, ensuring they are close enough for the jumper cables to reach.',
                ),
                _buildInstructionCard(
                  '2. Connect the Jumper Cables:',
                  'Connect the positive (+) terminal of the dead battery to the positive (+) terminal of the working battery. Then connect the negative (-) terminal of the working battery to a metal part of the dead car.',
                ),
                _buildInstructionCard(
                  '3. Start the Working Car:',
                  'Start the engine of the working car and let it run for a few minutes.',
                ),
                _buildInstructionCard(
                  '4. Start the Dead Car:',
                  'Attempt to start the engine of the dead car. If it starts, let it run for a few minutes.',
                ),
                _buildInstructionCard(
                  '5. Disconnect the Jumper Cables:',
                  'Remove the cables in the reverse order of how they were connected.',
                ),
                _buildInstructionCard(
                  '6. Let the Car Run:',
                  'Let the car run for at least 15 minutes to charge the battery.',
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
