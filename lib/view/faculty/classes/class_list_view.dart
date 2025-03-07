import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/routes/routes.dart';

class ClassListForAttendanceView extends StatefulWidget {
  const ClassListForAttendanceView({super.key});

  @override
  State<ClassListForAttendanceView> createState() => _ClassListForAttendanceViewState();
}

class _ClassListForAttendanceViewState extends State<ClassListForAttendanceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Class List',
        isBack: false,
        onTap: () async {
          dynamic result = await Get.toNamed(Routes.addEditClassesWithAttendanceView);
          if (result != null) {}
        },
      ),
      body: Center(
        child: AppTextTheme.textSize25(
          label: 'Class List',
          color: AppColors.black,
        ),
      ),
    );
  }
}
