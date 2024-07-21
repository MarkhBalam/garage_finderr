import 'package:flutter/material.dart';

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
        body: PaymentPage(),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildPaymentOption('Mobile Money', Icons.phone_android,  Colors.blue),
            Spacer(),
            _buildPaymentOption('Cash', Icons.attach_money, Colors.blue),
            Spacer(),
            _buildPaymentOption('Credit/Debit Card', Icons.credit_card,  Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          method,
          style: TextStyle(color: Colors.blue),
        ),
        trailing: Radio<String>(
          value: method,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
              if (method == 'Mobile Money') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MobileMoneyPage()),
                );
              }
            });
          },
        ),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
            if (method == 'Mobile Money') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MobileMoneyPage()),
              );
            }
          });
        },
      ),
    );
  }
}

class MobileMoneyPage extends StatefulWidget {
  @override
  _MobileMoneyPageState createState() => _MobileMoneyPageState();
}

class _MobileMoneyPageState extends State<MobileMoneyPage> {
  String _selectedOperator = '';

  void _handlePayment() {
    if (_selectedOperator.isNotEmpty) {
      // Call your payment API here with the selected operator
      print('Selected operator: $_selectedOperator');
      // TODO: Add API call here
    } else {
      // Show a message to select an operator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a mobile money operator')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Mobile Money Operator'),
      ),
      body: Column(
        children: <Widget>[
          _buildOperatorOption('Airtel'),
          _buildOperatorOption('MTN'),
          ElevatedButton(
            onPressed: _handlePayment,
            child: Text('Pay'),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorOption(String operator) {
    return ListTile(
      title: Text(operator),
      leading: Radio<String>(
        value: operator,
        groupValue: _selectedOperator,
        onChanged: (value) {
          setState(() {
            _selectedOperator = value!;
          });
        },
      ),
    );
  }
}
