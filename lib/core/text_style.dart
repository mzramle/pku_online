import 'package:flutter/material.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/core/colors.dart';

class FontSizes {
  static double scale = 1.2;
  static double get body => 14 * scale;
  static double get bodySm => 12 * scale;
  static double get title => 16 * scale;
  static double get titleM => 18 * scale;
  static double get sizeXXl => 28 * scale;
}

class TextStyles {
  static TextStyle get title => TextStyle(fontSize: FontSizes.title);
  static TextStyle get titleM => TextStyle(fontSize: FontSizes.titleM);
  static TextStyle get titleNormal =>
      title.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get titleMedium =>
      titleM.copyWith(fontWeight: FontWeight.w300);
  static TextStyle get h1Style =>
      TextStyle(fontSize: FontSizes.sizeXXl, fontWeight: FontWeight.bold);

  static TextStyle get body =>
      TextStyle(fontSize: FontSizes.body, fontWeight: FontWeight.w300);
  static TextStyle get bodySm => body.copyWith(fontSize: FontSizes.bodySm);
}

const TextStyle headline = TextStyle(
  fontSize: 28,
  color: white,
  fontWeight: FontWeight.bold,
);

const TextStyle headlineDot = TextStyle(
  fontSize: 30,
  color: blueText,
  fontWeight: FontWeight.bold,
);
const TextStyle headline1 = TextStyle(
  fontSize: 24,
  color: black,
  fontWeight: FontWeight.bold,
);

const TextStyle headline2 = TextStyle(
  fontSize: 14,
  color: whiteText,
  fontWeight: FontWeight.w600,
);
const TextStyle headline3 = TextStyle(
  fontSize: 14,
  color: grayText,
  fontWeight: FontWeight.bold,
);
const TextStyle hintStyle = TextStyle(
  fontSize: 14,
  color: grayText,
  fontWeight: FontWeight.bold,
);
