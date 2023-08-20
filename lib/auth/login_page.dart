import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swim_z/pages/home_page.dart';
import 'package:swim_z/pages/log_page.dart';

import '../pages/route.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordInvisible = true;

  void _login() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      print('Login successful!'); // Credentials are valid

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoutePage()),
      );
    } catch (e) {
      print('Login failed: $e'); // Credentials are invalid
      _showLoginErrorDialog();
    }
  }

  void _showLoginErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Error'),
        content: Text('Invalid email or password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _goToSignUpPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/water-bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 130.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/swimzen-logo.png',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.blue[800],
                  ),
                  // ... Other decoration properties ...
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.blue[800],
                  ),
                  // ... Other decoration properties ...
                ),
                obscureText: _passwordInvisible,
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _goToSignUpPage,
                    ),
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
