import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/colors.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/text_style.dart';

Widget textField({
  required String hintTxt,
  required String image,
  required TextEditingController controller,
  bool isObs = false,
  TextInputType? keyBordType,
  required String controllerName,
}) {
  return Container(
    height: 70.0,
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    margin: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    decoration: BoxDecoration(
      color: blackTextFild,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 270.0,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            obscureText: isObs,
            keyboardType: keyBordType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: hintStyle,
            ),
            style: headline1.copyWith(fontSize: 14.0),
          ),
        ),
        SvgPicture.asset(
          'assets/icon/$image',
          height: 20.0,
          color: grayText,
        )
      ],
    ),
  );
}
