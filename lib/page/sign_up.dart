import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/core/space.dart';
import 'package:pku_online/core/text_style.dart';
import 'package:pku_online/page/home_page.dart';
import 'package:pku_online/page/login_page.dart';
import 'package:pku_online/widget/main_button.dart';
import 'package:pku_online/widget/text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SpaceVH(height: 50.0),
              Text(
                'Create new account',
                style: headline1,
              ),
              SpaceVH(height: 10.0),
              Text(
                'Please fill in the form to continue',
                style: headline3,
              ),
              SpaceVH(height: 30.0),
              textField(
                controller: _nameTextController,
                image: 'user.svg',
                hintTxt: 'Username',
              ),
              textField(
                controller: _emailTextController,
                image: 'user.svg',
                hintTxt: 'Email Address',
              ),
              textField(
                controller: _phoneTextController,
                image: 'user.svg',
                hintTxt: 'Phone Number',
              ),
              textField(
                controller: _passwordTextController,
                isObs: true,
                image: 'hide.svg',
                hintTxt: 'Password',
              ),
              // textFild(
              //   controller: userPassConfirm,
              //   isObs: true,
              //   image: 'hide.svg',
              //   hintTxt: 'Confirm Password',
              // ),
              SpaceVH(height: 30.0),
              Mainbutton(
                onTap: () {
                  // Create user with email and password
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((userCredential) {
                    User? user = userCredential.user;
                    if (user != null) {
                      user.updateDisplayName(_nameTextController.text);
                    }
                    // Save sign-up form data to Firestore
                    FirebaseFirestore.instance
                        .collection('User')
                        .doc(userCredential
                            .user!.uid) // Use the user's UID as the document ID
                        .set({
                      'name': _nameTextController.text,
                      'password': _passwordTextController.text,
                      'email': _emailTextController.text,
                      'phone': _phoneTextController.text,
                      'role': 'user',
                    }).then((value) {
                      print('Sign-up form data saved to Firestore');
                    }).catchError((error) {
                      print('Failed to save sign-up form data: $error');
                    });

                    // Navigate to the login page after successful sign-up
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }).catchError((error) {
                    print('Failed to create user: $error');
                  });
                },
                text: 'Sign Up',
                btnColor: blueButton,
              ),

              SpaceVH(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Have an account? ',
                      style: headline3.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                    TextSpan(
                      text: ' Sign In',
                      style: headlineDot.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
