import 'package:flutter/material.dart';

class FluidsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Check and Top Up Fluids'),
        backgroundColor: Colors.blue,
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
                  '1. Locate the Fluid Reservoirs:',
                  'Find the reservoirs for oil, coolant, brake fluid, and windshield washer fluid.',
                ),
                _buildInstructionCard(
                  '2. Check Fluid Levels:',
                  'Use the dipstick for oil and check the level against the markings.',
                ),
                _buildInstructionCard(
                  '3. Top Up Fluids:',
                  'Add fluids as needed, following the recommendations in your owner’s manual.',
                ),
                _buildInstructionCard(
                  '4. Check for Leaks:',
                  'Look under the car for any signs of leaks.',
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
