import 'package:flutter/material.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';

class CollegeRegistrationView extends StatefulWidget {
  const CollegeRegistrationView({super.key});

  @override
  State<CollegeRegistrationView> createState() =>
      _CollegeRegistrationViewState();
}

class _CollegeRegistrationViewState extends State<CollegeRegistrationView> {
  late TextEditingController collegeNameController;

  @override
  void initState() {
    collegeNameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          LabeledTextFormField(
            labelText: LabelStrings.collegeName,
            controller: collegeNameController,
          ),
        ],
      ),
    );
  }
}
