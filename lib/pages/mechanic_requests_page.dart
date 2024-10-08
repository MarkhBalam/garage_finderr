import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class MechanicRequestsPage extends StatelessWidget {
  const MechanicRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic Requests'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('problems')
            .where('status',
                isEqualTo: 'pending') // Filter for pending requests
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests found.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data() as Map<String, dynamic>;
              final timestamp = (request['timestamp'] as Timestamp).toDate();
              final imageUrl =
                  request['imagePath'] as String? ?? ''; // Get image URL
              final requestId =
                  requests[index].id; // Get the document ID for updates
              final problemDescription =
                  request['problemDescription'] ?? 'No Description';
              final contactNumber = request['contactNumber'] ?? '';

              return Card(
                elevation: 5.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty) ...[
                      SizedBox(
                        height: 200, // Adjust height as needed
                        width: double.infinity, // Take full width of the card
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child;
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Car Model: ${request['carModel'] ?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Car Brand: ${request['carBrand'] ?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Contact Number: ${request['contactNumber'] ?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Problem Description: ${request['problemDescription'] ?? 'No Description'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Submitted On: ${timestamp.toLocal().toString()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Buttons for Accept and Ignore
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _acceptRequest(
                                  requestId, problemDescription, contactNumber);
                            },
                            child: const Text('Accept'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black, // Text color
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _ignoreRequest(
                                  requestId, problemDescription, contactNumber);
                            },
                            child: const Text('Ignore'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.black, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to handle accepting a request
  Future<void> _acceptRequest(
      String requestId, String problemDescription, String contactNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('problems')
          .doc(requestId)
          .update({
        'status': 'accepted',
      });

      // Add notification to the driver
      await FirebaseFirestore.instance.collection('notifications').add({
        'contactNumber': contactNumber,
        'message':
            'Your request about "$problemDescription" has been accepted.',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error
      print('Error accepting request: $e');
    }
  }

  // Method to handle ignoring a request
  Future<void> _ignoreRequest(
      String requestId, String problemDescription, String contactNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('problems')
          .doc(requestId)
          .delete(); // Delete the document

      // Add notification to the driver
      await FirebaseFirestore.instance.collection('notifications').add({
        'contactNumber': contactNumber,
        'message': 'Your request about "$problemDescription" has been ignored.',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error
      print('Error ignoring request: $e');
    }
  }
}
