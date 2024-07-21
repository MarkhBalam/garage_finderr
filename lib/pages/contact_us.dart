import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => ContactUsPage());
  }

  Future<void> _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'mugishabalam4@gmail.com',
      query: 'subject=Support%20Request', // Add subject and body here
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _launchCall() async {
    const url = 'tel:+256706772881';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _launchWhatsApp() async {
    const phoneNumber = '+256706772881';
    final url = 'https://wa.me/$phoneNumber?text=Hello%20Garage%20Finder';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Contact Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'If you have any questions or need assistance, please reach out to us. We\'re here to help!',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Contact Us Via',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue),
                    title: Text('Email Us'),
                    subtitle: Text('mugishabalam4@gmail.com'),
                    onTap: _launchEmail,
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.blue),
                    title: Text('Call Us'),
                    subtitle: Text('+256 706772881'),
                    onTap: _launchCall,
                  ),
                  ListTile(
                    leading: Icon(Icons.message, color: Colors.green),
                    title: Text('WhatsApp Us'),
                    subtitle: Text('+256 706772881'),
                    onTap: _launchWhatsApp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
