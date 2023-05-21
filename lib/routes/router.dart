import 'package:flutter/material.dart';
import 'package:pku_online/page/doctor_detail.dart';
import 'package:pku_online/page/splash_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => HomePage(),
  '/detail': (context) => SliverDoctorDetail(),
};
