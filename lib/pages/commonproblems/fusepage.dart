import 'package:flutter/material.dart';

class FusePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace a Fuse'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/fuse.jpg'), // Path to your background image
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
                  '1. Locate the Fuse Box:',
                  'Find the fuse box under the dashboard or under the hood.',
                ),
                _buildInstructionCard(
                  '2. Identify the Blown Fuse:',
                  'Look for the fuse that is burnt out or broken.',
                ),
                _buildInstructionCard(
                  '3. Remove the Blown Fuse:',
                  'Use a fuse puller or a pair of tweezers to remove the old fuse.',
                ),
                _buildInstructionCard(
                  '4. Install the New Fuse:',
                  'Place the new fuse into the correct slot.',
                ),
                _buildInstructionCard(
                  '5. Test the New Fuse:',
                  'Check if the electrical component works correctly.',
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
