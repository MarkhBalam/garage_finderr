import 'package:flutter/material.dart';
import 'package:garage_finder/components/my_button.dart';
import 'package:garage_finder/components/my_textfield.dart';
import 'package:garage_finder/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_finder/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in: $e'),
        ),
      );
    } finally {
      Navigator.pop(context);
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Incorrect Email'),
          content: const Text('The email address you entered does not exist.'),
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

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Incorrect Password'),
          content: const Text('The password you entered is incorrect.'),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.car_repair,
                  size: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                // page title
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),

                const SizedBox(height: 10),

                // subtitle
                Text(
                  'Ready to locate the nearest garage 😎!',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),

                const SizedBox(height: 30),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // sign in button
                MyButton(
                  text: 'Sign In',
                  onTap: signUserIn,
                ),

                const SizedBox(height: 40),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.blue[200],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 14,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.blue[200]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google.png',
                    ),
                    SizedBox(width: 20),
                    SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
                  ],
                ),

                const SizedBox(height: 40),

                // not a member? register now
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
    );
  }
}
