import 'package:flutter/material.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';

class AddEditFacultyView extends StatefulWidget {
  const AddEditFacultyView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditFacultyView> createState() => _AddEditFacultyViewState();
}

class _AddEditFacultyViewState extends State<AddEditFacultyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CommonAppBarPreferred(
        label: LabelStrings.faculty,
      ),
      body: Center(),
    );
  }
}
