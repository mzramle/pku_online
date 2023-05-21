import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pku_online/controller/signup_controller.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/core/space.dart';
import 'package:pku_online/core/text_style.dart';
import 'package:pku_online/page/home_page.dart';
import 'package:pku_online/widget/main_button.dart';
import 'package:pku_online/widget/text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            key: _formKey,
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
                controller: controller.fullName,
                controllerName: 'fullName',
                image: 'user.svg',
                keyBordType: TextInputType.name,
                hintTxt: 'Full Name',
              ),
              textField(
                controller: controller.email,
                controllerName: 'email',
                keyBordType: TextInputType.emailAddress,
                image: 'user.svg',
                hintTxt: 'Email Address',
              ),
              textField(
                controller: controller.phone,
                controllerName: 'phone',
                image: 'user.svg',
                keyBordType: TextInputType.phone,
                hintTxt: 'Phone Number',
              ),
              textField(
                controller: controller.password,
                controllerName: 'password',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
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
