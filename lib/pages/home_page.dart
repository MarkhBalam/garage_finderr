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

// Define a color palette
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.white;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
        Notifications(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        QuickAccessButton(
            icon: Icons.garage,
            label: 'Nearby\n Garages',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            }),
        QuickAccessButton(
          icon: Icons.build,
          label: 'Breakdown\n Assistance',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BreakdownAssistancePage()),
            );
          },
        ),
        QuickAccessButton(
          icon: Icons.report_problem,
          label: 'Common Car\n Problems',
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
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(icon, size: 38, color: Colors.blue),
                onPressed: onPressed,
              ),
            ),
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to RecentActivityPage when the card is tapped
        Navigator.push(
          context,
          RecentActivityPage
              .route(), // Use the named route to navigate to RecentActivityPage
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.history, color: primaryColor, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Activity',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    // List of recent activities
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notifications, color: primaryColor, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    // List of notifications
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
        // Navigate to SupportAndFeedbackPage when the card is tapped
        Navigator.push(
          context,
          SupportAndFeedbackPage
              .route(), // Use the named route to navigate to SupportAndFeedbackPage
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.support_agent, color: primaryColor, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Support and Feedback',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    // Support and feedback options
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
        // Navigate to PaymentPage when the card is tapped
        Navigator.push(
          context,
          PaymentPage.route(), // Use the named route to navigate to PaymentPage
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_balance_wallet, color: primaryColor, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    // User account and wallet details
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
