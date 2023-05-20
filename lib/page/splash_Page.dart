import 'package:flutter/material.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/colors.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/space.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/text_style.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/data/demo.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/page/login_page.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/widget/main_button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            height: height,
            color: blackBG,
            child: Image.asset(
              'assets/image/splash.png',
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'pkuonline',
                        style: headline,
                      ),
                      TextSpan(
                        text: '.',
                        style: headlineDot,
                      ),
                    ]),
                  ),
                  SpaceVH(height: 10.0),
                  Text(
                    splashText,
                    textAlign: TextAlign.center,
                    style: headline2,
                  ),
                  Mainbutton(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => LoginPage()));
                    },
                    btnColor: blueButton,
                    text: 'Get Started',
                  ),
                  SpaceVH(height: 20.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
