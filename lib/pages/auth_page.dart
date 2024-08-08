import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_finder/pages/home_page.dart';
import 'package:garage_finder/pages/login_or_register.dart';
import 'package:garage_finder/pages/mechanic_home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<String?> getUserRole(User user) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Check if document exists and has a role field
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.get('role');
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null; // Return null if any issue occurs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return FutureBuilder<String?>(
              future: getUserRole(snapshot.data!),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (roleSnapshot.hasData) {
                  final userRole = roleSnapshot.data;
                  if (userRole == 'driver') {
                    return HomePage();
                  } else if (userRole == 'mechanic') {
                    return MechanicHomePage();
                  }
                }

                // Provide a user-friendly message if role is missing or undefined
                return const Center(child: Text('Role not assigned or found.'));
              },
            );
          }

          return const LoginOrRegisterPage();
        },
      ),
    );
  }
}
