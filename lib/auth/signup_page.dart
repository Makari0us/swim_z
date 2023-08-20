import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swim_z/auth/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordInvisible = true;
  String? userUID;

  void _goToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _addUserDetails() async {
    final defaultPictureReference = FirebaseStorage.instance
        .ref()
        .child('Profile_Images')
        .child('default_profile_picture.png');

    final defaultPictureUrl = await defaultPictureReference.getDownloadURL();

    await FirebaseFirestore.instance.collection('Users').doc(userUID).set({
      'Name': _nameController.text.trim(),
      'Email': _emailController.text.trim(),
      'UserID': userUID,
      'Profile Picture': defaultPictureUrl,
    });
  }

  void _registerAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      // Registration is successful

      print('Registered user: ${userCredential.user?.uid}');
      userUID = userCredential.user!.uid;

      _addUserDetails();
      _goToLoginPage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorDialog(context,
            'The password provided is too weak (Length needs to be >= 6).');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog(
            context, 'An account is already attached to this email.');
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
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
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 170.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 40.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  prefixIcon: Icon(
                    Icons.person_2_outlined,
                    color: Colors.blue[800],
                  ),
                  // ... Other decoration properties ...
                ),
              ),
              SizedBox(height: 20.0),
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
                onPressed: _registerAccount,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                child: Text(
                  'Sign Up',
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
                  text: 'Have an account already? ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _goToLoginPage,
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
