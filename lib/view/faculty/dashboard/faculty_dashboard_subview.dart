import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class FacultyDashboardSubview extends StatefulWidget {
  const FacultyDashboardSubview({super.key});

  @override
  State<FacultyDashboardSubview> createState() => _FacultyDashboardSubviewState();
}

class _FacultyDashboardSubviewState extends State<FacultyDashboardSubview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Center(
        child: AppTextTheme.textSize25(
          label: 'Home',
          color: AppColors.black,
        ),
      ),
    );
  }
}
