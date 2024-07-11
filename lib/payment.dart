import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = ''; // Initialize with an empty string

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Cash'),
            leading: Radio<String>(
              value: 'Cash',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Credit/Debit Card'),
            leading: Radio<String>(
              value: 'Credit/Debit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Mobile Money'),
            leading: Radio<String>(
              value: 'Mobile Money',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle the "Next" button press (navigate to another page, etc.)
              // You can access the selected payment method using `_selectedPaymentMethod`
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
