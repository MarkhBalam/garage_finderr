import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final TextEditingController _mechanicController = TextEditingController();
  double _rating = 0.0;

  Future<void> _submitRating() async {
    if (_mechanicController.text.isEmpty || _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter mechanic name and rating.')),
      );
      return;
    }

    final mechanicName = _mechanicController.text;

    await FirebaseFirestore.instance.collection('ratings').add({
      'mechanic_name': mechanicName,
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rating submitted successfully!')),
    );

    _mechanicController.clear();
    setState(() {
      _rating = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate a Mechanic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _mechanicController,
              decoration: InputDecoration(labelText: 'Mechanic Name'),
            ),
            SizedBox(height: 16.0),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              itemCount: 5,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitRating,
              child: Text('Submit Rating'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('ratings').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final ratings = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      final rating = ratings[index].data() as Map<String, dynamic>;
                      final mechanicName = rating['mechanic_name'];
                      final ratingValue = rating['rating'].toDouble();

                      return ListTile(
                        title: Text(mechanicName),
                        subtitle: Text('Rating: ${ratingValue.toStringAsFixed(1)}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
