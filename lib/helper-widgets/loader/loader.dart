import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? AppColors.primaryColor,
      strokeWidth: 1,
    );
  }
}
