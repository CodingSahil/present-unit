import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class AssignmentListView extends StatefulWidget {
  const AssignmentListView({super.key});

  @override
  State<AssignmentListView> createState() => _AssignmentListViewState();
}

class _AssignmentListViewState extends State<AssignmentListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Center(
        child: AppTextTheme.textSize25(
          label: 'Assignment List',
          color: AppColors.black,
        ),
      ),
    );
  }
}
