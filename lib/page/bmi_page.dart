import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pku_online/core/Icon_Content.dart';
import 'package:pku_online/core/Reusable_Bg.dart';
import 'package:pku_online/core/RoundIcon_Button.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/data/constants.dart';
import 'Results_Page.dart';
import 'package:pku_online/core/BottomContainer_Button.dart';
import 'package:pku_online/core/calculator.dart';

enum Gender {
  male,
  female,
}

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  late Gender selectedGender = Gender.male;
  int height = 180;
  int weight = 50;
  int age = 20;

  // Declare Firestore collection reference and current user ID
  CollectionReference userBMIResultCollection =
      FirebaseFirestore.instance.collection('userBMIResult');
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    // Get the current user ID
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // Save BMI data to Firestore
  void saveData() async {
    Calculate calc = Calculate(height: height, weight: weight);

    // Prepare the data to be stored
    final data = {
      'userId': currentUserId,
      'gender': selectedGender.toString().split('.').last,
      'height': height,
      'weight': weight,
      'age': age,
      'bmi': calc.result(),
      'resultText': calc.getText(),
      'advise': calc.getAdvise(),
    };

    // Store the data in Firestore
    await userBMIResultCollection.doc(currentUserId).set(data);

    // Navigate to the ResultPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          bmi: calc.result(),
          resultText: calc.getText(),
          advise: calc.getAdvise(),
          textColor: calc.getTextColor(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: blueButton,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    child: ReusableBg(
                      colour:
                          selectedGender == Gender.male ? blueButton : grayText,
                      cardChild: IconContent(
                        myicon: FontAwesomeIcons.mars,
                        text: 'MALE',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    child: ReusableBg(
                      colour: selectedGender == Gender.female
                          ? blueButton
                          : grayText,
                      cardChild: IconContent(
                        myicon: FontAwesomeIcons.venus,
                        text: 'FEMALE',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableBg(
              colour: blueButton,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HEIGHT',
                    style: klabelTextStyle.copyWith(color: white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        height.toString(),
                        style: kDigitTextStyle.copyWith(color: white),
                      ),
                      Text(
                        'cm',
                        style: klabelTextStyle.copyWith(color: white),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Color(MyColors.grey02),
                      thumbColor: Color(MyColors.bg01),
                      overlayColor: Color(0x29EB1555),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 35.0),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 100.0,
                      max: 220.0,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableBg(
                    colour: blueButton,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'WEIGHT',
                          style: klabelTextStyle.copyWith(color: white),
                        ),
                        Text(
                          weight.toString(),
                          style: kDigitTextStyle.copyWith(color: white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  weight--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableBg(
                    colour: blueButton,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AGE',
                          style: klabelTextStyle.copyWith(color: white),
                        ),
                        Text(
                          age.toString(),
                          style: kDigitTextStyle.copyWith(color: white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  age--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomContainer(
            text: 'Calculate',
            onTap: saveData,
          ),
        ],
      ),
    );
  }
}
