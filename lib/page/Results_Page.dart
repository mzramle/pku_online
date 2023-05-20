import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/BottomContainer_Button.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/colors.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/Reusable_Bg.dart';

class ResultPage extends StatelessWidget {
  final String resultText;
  final String bmi;
  final String advise;
  final Color textColor;

  ResultPage(
      {required this.textColor,
      required this.resultText,
      required this.bmi,
      required this.advise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: blueButton,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomCenter,
              child: Text(
                'Your Result',
                style: ktitleTextStyle.copyWith(fontSize: 34),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableBg(
              colour: Color(MyColors.bg01),
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    resultText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    bmi,
                    style: kBMITextStyle,
                  ),
                  Text(
                    'Normal BMI range:',
                    style: klabelTextStyle.copyWith(color: grayText),
                  ),
                  Text(
                    '18.5 - 25 kg/m2',
                    style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    advise,
                    textAlign: TextAlign.center,
                    style: kBodyTextStyle.copyWith(color: blueButton),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
          BottomContainer(
              text: 'Re-Calculate',
              onTap: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
