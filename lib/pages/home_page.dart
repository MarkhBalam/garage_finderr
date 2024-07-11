import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:garage_finder/pages/notifications.dart";
import "package:garage_finder/pages/payments.dart";

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
        SearchBar(),
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

class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'My Account Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              'Welcome, $userName!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            Icon(
              Icons.person,
              size: 32,
              color: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for garages...',
        prefixIcon: Icon(Icons.search, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: secondaryColor,
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
        QuickAccessButton(icon: Icons.garage, label: 'Nearby Garages'),
        QuickAccessButton(icon: Icons.build, label: 'Breakdown Assistance'),
        QuickAccessButton(icon: Icons.lightbulb, label: 'DIY Solutions'),
      ],
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickAccessButton({required this.icon, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: 32, color: primaryColor),
            onPressed: () {
              // Navigate to respective page
            },
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: primaryColor)),
      ],
    );
  }
}

class RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // List of recent activities
          ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // List of notifications
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Support and Feedback',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Support and feedback options
          ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account and Wallet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // User account and wallet details
            ],
          ),
        ),
      ),
    );
  }
}
