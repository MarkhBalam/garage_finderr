import 'package:flutter/material.dart';

class SupportAndFeedbackPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => SupportAndFeedbackPage());
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    void _submitFeedback() {
      final feedbackMessage = _messageController.text;
      // Handle feedback submission logic here (e.g., send feedbackMessage to the backend or Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );
      _messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Support and Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Type your Message here',
                  labelStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Thank you for your feedback!',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
