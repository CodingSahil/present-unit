import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color(0xff1f41bb);
  static Color black = const Color(0xff000000);
  static Color white = const Color(0xffffffff);
  static Color red = const Color(0xffff0000);
  static Color green = const Color(0xff2bbc30);
  static Color lightTextColor = AppColors.black.withAlpha(
    (255 * 0.6).toInt(),
  );
  static Color transparent = Colors.transparent;
}
