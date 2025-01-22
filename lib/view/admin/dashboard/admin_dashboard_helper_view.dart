import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/enum/admin_enum.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class AdminDashboardHelperView extends StatefulWidget {
  const AdminDashboardHelperView({
    super.key,
    required this.selectTab,
  });

  final AdminBottomNavigationBarEnums selectTab;

  @override
  State<AdminDashboardHelperView> createState() =>
      _AdminDashboardHelperViewState();
}

class _AdminDashboardHelperViewState extends State<AdminDashboardHelperView> {
  String titleForBottomNavigationBarEnums({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return LabelStrings.home;
      case AdminBottomNavigationBarEnums.course:
        return LabelStrings.course;
      case AdminBottomNavigationBarEnums.classList:
        return LabelStrings.classList;
      case AdminBottomNavigationBarEnums.faculty:
        return LabelStrings.faculty;
      case AdminBottomNavigationBarEnums.subject:
        return LabelStrings.subject;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppTextTheme.textSize20(
        label: titleForBottomNavigationBarEnums(
          bottomNavigationBarEnums: widget.selectTab,
        ),
        color: AppColors.black,
      ),
    );
  }
}
