import 'package:flutter/material.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/colors.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/space.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/text_style.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/page/home_page.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/page/sign_up.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/widget/main_button.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/widget/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController userPass = TextEditingController();
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
                controller: userName,
                controllerName: 'userName',
                image: 'user.svg',
                hintTxt: 'Username',
              ),
              textField(
                controller: userPass,
                controllerName: 'userPass',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      text: 'Sign in',
                      btnColor: blueButton,
                    ),
                    SpaceVH(height: 20.0),
                    Mainbutton(
                      onTap: () {},
                      text: 'Sign in with google',
                      image: 'google.png',
                      btnColor: black,
                      txtColor: white,
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
