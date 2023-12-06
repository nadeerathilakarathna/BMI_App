import 'package:bmiapp/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bmiapp/screens/login_screen.dart';
import 'package:bmiapp/alert/custom_alert_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();


  Future<void> _signup() async {
    if (_passwordController.text != _retypePasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Mismatch'),
          content: const Text('Passwords do not match. Please re-enter.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Signup successful, navigate to the LoginScreenNew
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // Handle signup errors and show error dialog
      String errorMessage = 'An error occurred while logging in. Please try again.';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email address is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          case 'weak-password':
            errorMessage =
            'Password is too weak. Please choose a stronger password.';
            break;
          default:
            errorMessage =
            'An error occurred while signing up. Please try again.';
            break;
        }
      }

      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Login Error',
          message: errorMessage,
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
        ),
      );

      print('Signup failed: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('BMI Calculator')),
      ),
      body: Column(
        children: [
          const SizedBox(height: 11,),
          const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter Email',
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Enter password',
              prefixIcon: Icon(Icons.key),
              hintText: 'Enter your password',
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          TextField(
            controller: _retypePasswordController,
            decoration: InputDecoration(
              labelText: 'Re-type password',
              prefixIcon: Icon(Icons.key),
              hintText: 'Re-enter your password',
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          const SizedBox(height: 11,),
          ElevatedButton(
            onPressed: _signup,
            child: const Text('Sign Up'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'If you already have an account? Login',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
