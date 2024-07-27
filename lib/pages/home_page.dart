import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:garage_finder/pages/notifications.dart";
import "package:garage_finder/pages/payments.dart";
import 'package:garage_finder/pages/common_car_problems.dart';
import 'package:garage_finder/pages/map_pages.dart';
import "package:garage_finder/pages/breakdown_assistance.dart";
import "package:garage_finder/pages/recent_activity.dart";
import "package:garage_finder/pages/support_and_feedback.dart";
import "package:garage_finder/pages/about_us.dart";
import "package:garage_finder/pages/contact_us.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:garage_finder/pages/problem_description.dart';

// Define a color palette
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.white;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
                context, 'garage_finder/lib/pages/rating_page.dart');
          },
          child: const Text('garage_finder/lib/pages/rating_page.dart'),
        ),
      ),
    );
    // TODO: implement ==
    //return super == other;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fetch user name from Firestore
  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc.data()?['username'] ?? 'User';
      });
    }
  }

  // Sign out user method
  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login page or show a message
    } catch (e) {
      // Handle sign out errors
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: const Text('Garage Finder',
              style: TextStyle(color: secondaryColor)),
        ),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 30.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '0', // Replace '0' with the actual count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeContent(userName: userName),
          MyAccountPage(),
          PlaceholderWidget(
              label: 'Logout Placeholder'), // Placeholder for logout
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: (int index) {
          setState(() {
            if (index == 2) {
              signUserOut();
            } else {
              _selectedIndex = index;
            }
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String? userName;

  const HomeContent({Key? key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        WelcomeBanner(userName: userName ?? 'User'),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        QuickAccessButtons(),
        const SizedBox(height: 16),
        RecentActivity(),
        const SizedBox(height: 16),
        SupportAndFeedback(),
        const SizedBox(height: 16),
        UserAccountAndWallet(),
      ],
    );
  }
}

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch user details from Firestore
  Future<void> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc.data()?['username'] ?? 'User';
        userEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        UserDetailsCard(
            userName: userName ?? 'User',
            userEmail: userEmail ?? 'Not available'),
        const SizedBox(height: 16),
        AboutUsSection(),
        const SizedBox(height: 16),
        ContactUsSection(),
      ],
    );
  }
}

class UserDetailsCard extends StatelessWidget {
  final String userName;
  final String userEmail;

  const UserDetailsCard(
      {required this.userName, required this.userEmail, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.2),
              child: Icon(Icons.person, color: primaryColor, size: 56),
              radius: 36,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                  Text(userName,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                  const SizedBox(height: 8),
                  Text('Email',
                      style: TextStyle(fontSize: 21, color: Colors.grey[500])),
                  Text(userEmail,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to AboutUsPage when the card is tapped
        Navigator.push(
          context,
          AboutUsPage.route(), // Use the named route to navigate to AboutUsPage
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: primaryColor, size: 40),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About Us',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    // About us details
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ContactUsPage when the card is tapped
        Navigator.push(
          context,
          ContactUsPage
              .route(), // Use the named route to navigate to ContactUsPage
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.contact_mail, color: primaryColor, size: 40),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Us',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    // Contact us details
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;

  const PlaceholderWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  final String userName;

  const WelcomeBanner({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Welcome , $userName😊!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuickAccessButton(
          width: screenWidth,
          imagePath: 'lib/images/trial_form.jpg',
          label:
              'Fill the Car Problem Description form first to locate the nearest a suitable garage',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProblemDescriptionFormPage()),
            );
          },
        ),
        QuickAccessButton(
          width: screenWidth,
          imagePath: 'lib/images/c.jpg',
          label: 'Breakdown Assistance',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BreakdownAssistancePage()),
            );
          },
        ),
        QuickAccessButton(
          width: screenWidth,
          imagePath: 'lib/images/common.jpg',
          label: 'Common Car Problems and Solutions',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommonCarProblemsPage()),
            );
          },
        ),
      ],
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final double width;
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const QuickAccessButton({
    required this.width,
    required this.imagePath,
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width * 0.9, // Adjust width for better spacing
        margin: const EdgeInsets.symmetric(
            vertical: 12), // Increased vertical margin
        padding: const EdgeInsets.all(0), // Removed padding
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(15), // Larger radius for rounded corners
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.lightBlue
            ], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12), // Padding for text container
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // White text for contrast
                  fontSize: 18, // Slightly larger font size
                  fontWeight: FontWeight.bold, // Bold text for emphasis
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ), // Rounded bottom corners for the image
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 200, // Height for larger images
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentActivityPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => RecentActivityPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Recent Activity'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/recent.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('problems')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final recentActivities = snapshot.data!.docs;

              return ListView.builder(
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  final data = activity.data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['problemDescription'] ?? 'No description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Car Brand: ${data['carBrand'] ?? 'No brand'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          Text(
                            'Car Model: ${data['carModel'] ?? 'No model'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          Text(
                            'Contact: ${data['contactNumber'] ?? 'No contact'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          if (data['imagePath'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['imagePath'],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.access_time,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 5),
                              Text(
                                data['timestamp'] != null
                                    ? (data['timestamp'] as Timestamp)
                                        .toDate()
                                        .toString()
                                    : 'No timestamp',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          RecentActivityPage.route(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.history, color: primaryColor, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Activity',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    Text('Check your recent activities here.',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notifications, color: primaryColor, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    Text('Check your notifications here.',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportAndFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SupportAndFeedbackPage.route(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.support_agent, color: primaryColor, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Support and Feedback',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    Text('Get support and provide feedback.',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserAccountAndWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PaymentPage.route(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_balance_wallet, color: primaryColor, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payments',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    Text('Manage your payments here.',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//class home_page extends StatelessWidget
