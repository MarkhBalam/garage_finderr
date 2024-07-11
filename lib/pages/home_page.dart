import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_finder/pages/payments.dart';

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
          child: const Text(
            'Garage Finder',
            style: TextStyle(color: secondaryColor),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WelcomeBanner(userName: userName),
          const SizedBox(height: 16),
          const SearchBar(),
          const SizedBox(height: 16),
          const QuickAccessButtons(),
          const SizedBox(height: 16),
          const RecentActivity(),
          const SizedBox(height: 16),
          const Notifications(),
          const SizedBox(height: 16),
          const SupportAndFeedback(),
          const SizedBox(height: 16),
          const UserAccountAndWallet(),
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
        currentIndex: 0,
        selectedItemColor: primaryColor,
        onTap: (int index) {
          switch (index) {
            case 1:
              // Navigate to My Account page (PaymentPage)
              Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage()));
              break;
            case 2:
              signUserOut();
              break;
          }
        },
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  final String? userName;

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
              userName != null ? 'Welcome, $userName!' : 'Welcome!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            // Optional: Add a profile icon
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
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for garages...',
        prefixIcon: const Icon(Icons.search, color: primaryColor),
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
  const QuickAccessButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
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
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: primaryColor)),
      ],
    );
  }
}

class RecentActivity extends StatelessWidget {
  const RecentActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const Column(
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
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // List of notifications
          ],
        ),
      ),
    );
  }
}

class SupportAndFeedback extends StatelessWidget {
  const SupportAndFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const Column(
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
  const UserAccountAndWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account and Wallet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // User account and wallet details
          ],
        ),
      ),
    );
  }
}
