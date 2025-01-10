import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/login_controller.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/routes/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late LoginController loginController;

  bool clickOnSave = false;

  @override
  void initState() {
    super.initState();
    loginController = Get.find<LoginController>();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    loginController.getAdminList();
  }

  bool validateFields() =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.04,
          horizontal: MediaQuery.sizeOf(context).width * 0.09,
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.175,
            ),
            AppTextTheme.textSize30(
              label: LabelStrings.loginHere,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: Dimens.height42),
            AppTextTheme.textSize18(
              label: LabelStrings.loginInstruction,
              color: AppColors.black,
            ),
            SizedBox(height: Dimens.height56),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.email,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  labelText: '',
                  hintText: LabelStrings.enterEmail,
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  isError: clickOnSave && emailController.text.isEmpty,
                  errorMessage: '${LabelStrings.email} ${LabelStrings.require}',
                  onChanged: (value) {
                    setState(() {});
                  },
                  onFieldSubmitted: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(height: Dimens.height36),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.password,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  labelText: '',
                  hintText: LabelStrings.enterPassword,
                  controller: passwordController,
                  isError: clickOnSave && passwordController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.password} ${LabelStrings.require}',
                  onChanged: (value) {
                    setState(() {});
                  },
                  onFieldSubmitted: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(height: Dimens.height36),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.forgotPassword,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
            SizedBox(height: Dimens.height60),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                setState(() {
                  clickOnSave = !validateFields();
                });

                if(validateFields()) {
                  await loginController.getAdminList();
                  if (loginController.adminList.isNotEmpty &&
                      loginController.adminList.any(
                        (element) =>
                            (element.email.toLowerCase() ==
                                    emailController.text.toLowerCase() ||
                                element.mobileNumber == emailController.text) &&
                            element.password == passwordController.text,
                      )) {
                    loginController.loader(true);
                    showSuccessSnackBar(
                      context: context,
                      title: 'User is Available and successfully login!',
                    );
                    loginController.loader(false);
                    emailController.clear();
                    passwordController.clear();
                  } else {
                    showErrorSnackBar(
                      context: context,
                      title: 'User doesn\'t exist',
                    );
                  }
                }
              },
              child: SubmitButtonHelper(
                width: MediaQuery.sizeOf(context).width,
                height: Dimens.height80,
                child: Obx(
                  () => loginController.loader.value
                      ? SizedBox(
                          height: Dimens.height24,
                          width: Dimens.width24,
                          child: Loader(
                            color: AppColors.white,
                          ),
                        )
                      : AppTextTheme.textSize16(
                          label: LabelStrings.signIn,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
            SizedBox(height: Dimens.height50),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                var result = await Get.toNamed(
                  Routes.registration,
                );

                if (result is bool && result == true) {
                  showSuccessSnackBar(
                    context: context,
                    title: LabelStrings.userRegisteredSuccess,
                  );
                }
              },
              child: AppTextTheme.textSize16(
                label: LabelStrings.createNewAccount,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
