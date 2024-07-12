import 'package:flutter/material.dart';
import 'package:garage_finder/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Payment Example'),
        ),
        body: UserAccountAndWallet(), // Example of starting widget
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => PaymentPage());

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = ''; // Initialize with an empty string

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Payment Method',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0), // Add padding to the main container
        child: Column(
          children: <Widget>[
            _buildPaymentOption('Cash'),
            Spacer(), // Add space between the options
            _buildPaymentOption('Credit/Debit Card'),
            Spacer(), // Add space between the options
            _buildPaymentOption('Mobile Money'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Grey background color for the Container
        borderRadius: BorderRadius.circular(8.0), // Optional: round the corners
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Text(
          method,
          style: TextStyle(color: Colors.black), // Black text color
        ),
        leading: Radio<String>(
          value: method,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Colors.blue,
        ),
      ),
    );
  }
}
