import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/payment.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildPaymentOption(
                'Mobile Money', Icons.phone_android, Colors.blue),
            Spacer(),
            _buildPaymentOption('Cash', Icons.attach_money, Colors.green),
            Spacer(),
            _buildPaymentOption(
                'Credit/Debit Card', Icons.credit_card, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon, Color color) {
    return GestureDetector(
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: color, size: 30),
          title: Text(
            method,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
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
        ),
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
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/payment.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            _buildOperatorOption('Airtel', Colors.red),
            _buildOperatorOption('MTN', Colors.yellow),
            Spacer(),
            ElevatedButton(
              onPressed: _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text('Pay', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorOption(String operator, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOperator = operator;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(Icons.radio_button_checked, color: color),
          title: Text(
            operator,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          trailing: Radio<String>(
            value: operator,
            groupValue: _selectedOperator,
            onChanged: (value) {
              setState(() {
                _selectedOperator = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}
