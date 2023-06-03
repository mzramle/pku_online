import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/core/space.dart';
import 'package:pku_online/core/text_style.dart';
import 'package:pku_online/page/home_page.dart';
import 'package:pku_online/page/sign_up.dart';
import 'package:pku_online/widget/main_button.dart';
import 'package:pku_online/widget/text_field.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                'Welcome Back!',
                style: headline1,
              ),
              SpaceVH(height: 10.0),
              Text(
                'Please sign in to your account',
                style: headline3,
              ),
              SpaceVH(height: 60.0),
              textField(
                controller: emailController,
                image: 'user.svg',
                hintTxt: 'Email',
              ),
              textField(
                controller: passwordController,
                image: 'hide.svg',
                isObs: true,
                hintTxt: 'Password',
              ),
              SpaceVH(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: headline3,
                    ),
                  ),
                ),
              ),
              SpaceVH(height: 100.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Mainbutton(
                      onTap: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }).catchError((error) {
                          print("Error signing in: $error");
                          // Handle specific error cases
                          String errorMessage =
                              "An error occurred during sign-in.";
                          if (error is FirebaseAuthException) {
                            switch (error.code) {
                              case 'user-not-found':
                                errorMessage =
                                    "No user found with the provided email.";
                                break;
                              case 'wrong-password':
                                errorMessage = "Invalid password.";
                                break;
                              case 'invalid-email':
                                errorMessage = "The email address is invalid.";
                                break;
                              // Add more specific error cases as needed
                            }
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Sign-In Error"),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                      text: 'Sign in',
                      btnColor: blueButton,
                    ),
                    SpaceVH(height: 20.0),
                    Mainbutton(
                      onTap: () async {
                        try {
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          final GoogleSignInAccount? googleUser =
                              await googleSignIn.signIn();

                          if (googleUser == null) {
                            // Google sign-in canceled by the user
                            return;
                          }

                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                          final OAuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          final UserCredential userCredential =
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                          // User sign-in or sign-up successful
                          print(
                              "Signed in with Google: ${userCredential.user?.displayName}");

                          // Navigate to the desired screen after successful sign-in
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } catch (e) {
                          // Handle any errors that occur during sign-in or sign-up
                          print("Error signing in with Google: $e");
                        }
                      },
                      text: 'Sign in with Google',
                      image: 'google.png',
                      btnColor: Colors.black,
                      txtColor: Colors.white,
                    ),
                    SpaceVH(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignUpPage()));
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: headline3.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ' Sign Up',
                            style: headlineDot.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
