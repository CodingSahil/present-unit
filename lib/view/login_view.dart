import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Center(
            child: AppTextTheme.textSize25(
              label: LabelStrings.adminEmail,
            ),
          ),
        ],
      ),
    );
  }
}
