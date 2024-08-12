import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:intl/intl.dart'; // Import the intl package

class PaymentService {
  final String publicKey = 'FLWPUBK_TEST-e931b80b1f9dc244f8f9466593f25269-X';
  final String secretKey = 'FLWSECK_TEST-2765a8ccd0ebbe629792bb9314f4e1ef-X';

  Future<bool> initiatePayment({
    required BuildContext context,
    required String amount,
    required String currency,
    required String email,
    required String txRef,
    required String phoneNumber,
  }) async {
    final Customer customer = Customer(
      name: "User",
      phoneNumber: phoneNumber,
      email: email,
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: publicKey,
      currency: currency,
      amount: amount,
      customer: customer,
      paymentOptions: "mobilemoneyuganda",
      customization: Customization(title: "Live Payment"),
      txRef: txRef,
      isTestMode: true, // Change to false for live payments
      redirectUrl: "https://your-redirect-url.com", // You can use any URL for testing
    );

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response != null && response.status == "successful") {
        return true;
      } else {
        print("Transaction failed");
        return false;
      }
    } catch (error) {
      print("An error occurred: $error");
      return false;
    }
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/payment.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildPaymentOption('Mobile Money', Icons.phone_android, Colors.blue),
            Spacer(),
            _buildPaymentOption('Cash', Icons.attach_money, Colors.green),
            Spacer(),
            _buildPaymentOption('Credit/Debit Card', Icons.credit_card, Colors.orange),
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
              MaterialPageRoute(
                builder: (context) => MobileMoneyPage(operator: method),
              ),
            );
          } else if (method == 'Cash') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CashPaymentPage()),
            );
          } else if (method == 'Credit/Debit Card') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreditCardPage()),
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
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),
      ),
    );
  }
}

class MobileMoneyPage extends StatefulWidget {
  final String operator;

  MobileMoneyPage({required this.operator});

  @override
  _MobileMoneyPageState createState() => _MobileMoneyPageState();
}

class _MobileMoneyPageState extends State<MobileMoneyPage> {
  String _selectedOperator = '';
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedOperator = widget.operator;
  }

  void _handlePayment() async {
    if (_selectedOperator.isNotEmpty) {
      // Validate the input fields
      if (_phoneNumberController.text.isEmpty || _amountController.text.isEmpty || _emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      final paymentService = PaymentService();
      bool result = await paymentService.initiatePayment(
        context: context,
        amount: _amountController.text,
        currency: 'UGX',
        email: _emailController.text,
        txRef: DateTime.now().millisecondsSinceEpoch.toString(),
        phoneNumber: _phoneNumberController.text,
      );

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a mobile money operator')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Money Payment'),
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
            Text(
              'Operator: ${_selectedOperator}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'UGX e.g. 40,000',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixText: 'UGX',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'e.g. name@email.com',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
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
}

class CashPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Proceed to pay with cash.'),
      ),
    );
  }
}

class CreditCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit/Debit Card Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Proceed to pay with a credit/debit card.'),
      ),
    );
  }
}


