import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:garage_finder/services/auth_services.dart'; // Ensure correct path
import 'package:garage_finder/components/my_button.dart';
import 'package:garage_finder/components/my_textfield.dart';
import 'package:garage_finder/pages/home_page.dart';
import 'package:garage_finder/pages/mechanic_home_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'driver'; // Default role
  bool _isLoading = false; // Track loading state

  // Method to handle location permissions
  Future<void> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
    }
  }

  // Method to sign in the user and capture their location
  void signUserIn() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Handle location permission
      await _handleLocationPermission();

      // Sign in the user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // Save the user's role in Firestore
      await AuthService().setUserRole(userCredential.user!.uid, selectedRole);

      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Store the location in Firestore under the user's ID
      await FirebaseFirestore.instance
          .collection('locations')
          .doc(userCredential.user!.uid)
          .set({
        'role': selectedRole,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // Close loading dialog

      // Navigate to the appropriate home page based on the user's role
      if (selectedRole == 'driver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (selectedRole == 'mechanic') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MechanicHomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.code);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Method to show an error dialog
  void showErrorDialog(String errorCode) {
    String title, message;
    if (errorCode == 'user-not-found') {
      title = 'Incorrect Email';
      message = 'The email address you entered does not exist.';
    } else if (errorCode == 'wrong-password') {
      title = 'Incorrect Password';
      message = 'The password you entered is incorrect.';
    } else {
      title = 'Error';
      message = 'An unknown error occurred.';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.blue)
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.car_repair,
                            size: 100,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ready to locate the nearest garage 😎!',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // "Login as" label with Role dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Login as',
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedRole,
                                  items: <String>['driver', 'mechanic']
                                      .map((String role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRole = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email textfield
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),

                        // Password textfield
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),

                        // Sign in button
                        MyButton(
                          text: 'Sign In',
                          onTap: signUserIn,
                        ),
                        const SizedBox(height: 40),

                        // Not a member? Register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Not a member?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                'Register now',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
