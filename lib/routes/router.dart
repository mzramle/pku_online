import 'package:flutter/material.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/page/doctor_detail.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/page/splash_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => HomePage(),
  '/detail': (context) => SliverDoctorDetail(),
};
