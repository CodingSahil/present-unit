import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/controller/change_password_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/form_fields_with_label.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/view/splash_view.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final ChangePasswordController changePasswordController;
  UserType userType = UserType.none;
  Admin? admin;
  Faculty? faculty;
  bool isError = false;
  late GetStorage getStorage;
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    changePasswordController = Get.find<ChangePasswordController>();
    getStorage = GetStorage();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (widget.arguments != null && widget.arguments is UserType) {
          userType = widget.arguments as UserType;

          if (userType == UserType.admin && userDetails != null && userDetails!.admin != null) {
            admin = userDetails!.admin!;
            await changePasswordController.getAdminList();
          }
          if (userType == UserType.faculty && userDetails != null && userDetails!.faculty != null) {
            faculty = userDetails!.faculty!;
            await changePasswordController.getFacultyList();
          }
        }
      },
    );

    super.initState();
  }

  bool validate() =>
      currentPasswordController.text.isNotEmpty &&
      passwordRegex.hasMatch(currentPasswordController.text) &&
      newPasswordController.text.isNotEmpty &&
      newPasswordController.text.length >= 6 &&
      passwordRegex.hasMatch(newPasswordController.text) &&
      confirmPasswordController.text.isNotEmpty &&
      confirmPasswordController.text.length >= 6 &&
      passwordRegex.hasMatch(confirmPasswordController.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Change Password',
      ),
      body: Obx(
        () => changePasswordController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.height32,
                  horizontal: Dimens.width30,
                ),
                children: [
                  AppTextTheme.textSize18(
                    label: 'Hello, ${getName()}!',
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Dimens.height8),
                  AppTextTheme.textSize15(
                    label: 'Enter your current, new, and confirm password in their respective fields to change your password.',
                    maxLines: 3,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: Dimens.height60),
                  AppTextFormFieldsWithLabel(
                    textEditingController: currentPasswordController,
                    hintText: 'Current Password',
                    isError: isError && (currentPasswordController.text.isEmpty || !passwordRegex.hasMatch(currentPasswordController.text)),
                    errorMessage: !passwordRegex.hasMatch(currentPasswordController.text)
                        ? 'Current Password must contain at least:- 1 uppercase letter,\n1 lowercase letter, 1 number, 1 special character'
                        : null,
                    isPasswordField: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onFieldSubmitted: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: Dimens.height30),
                  AppTextFormFieldsWithLabel(
                    textEditingController: newPasswordController,
                    hintText: 'New Password',
                    isError: isError && (newPasswordController.text.isEmpty || newPasswordController.text.length < 6 || !passwordRegex.hasMatch(newPasswordController.text)),
                    errorMessage: !passwordRegex.hasMatch(newPasswordController.text)
                        ? 'New Password must contain at least:- 1 uppercase letter,\n1 lowercase letter, 1 number, 1 special character'
                        : newPasswordController.text.length < 6
                            ? 'New Password length must at least 6'
                            : null,
                    isPasswordField: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onFieldSubmitted: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: Dimens.height30),
                  AppTextFormFieldsWithLabel(
                    textEditingController: confirmPasswordController,
                    hintText: 'Confirm Password',
                    isError: isError && (confirmPasswordController.text.isEmpty || confirmPasswordController.text.length < 6 || !passwordRegex.hasMatch(confirmPasswordController.text)),
                    errorMessage: !passwordRegex.hasMatch(confirmPasswordController.text)
                        ? 'Confirm Password must contain at least:- 1 uppercase letter,\n1 lowercase letter, 1 number, 1 special character'
                        : confirmPasswordController.text.length < 6
                            ? 'Confirm Password length must at least 6'
                            : null,
                    isPasswordField: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onFieldSubmitted: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: Dimens.height60),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      setState(() {
                        isError = !validate();
                      });

                      if (isError) return;

                      if (currentPasswordController.text == newPasswordController.text) {
                        showErrorSnackBar(
                          context: context,
                          title: 'Current password and New password looks like same',
                        );
                        return;
                      }

                      if (newPasswordController.text != confirmPasswordController.text) {
                        showErrorSnackBar(
                          context: context,
                          title: 'New password and Confirm password seems to be same',
                        );
                        return;
                      }

                      /// operation on Admin
                      if (userType == UserType.admin &&
                          admin != null &&
                          changePasswordController.adminList.any(
                            (element) => element.id == admin!.id,
                          )) {
                        if (admin!.password != currentPasswordController.text) {
                          showErrorSnackBar(
                            context: context,
                            title: 'Wrong Current Password',
                          );
                        } else {
                          Admin adminLocal = changePasswordController.adminList.firstWhere(
                            (element) => element.id == admin!.id,
                          );

                          adminLocal = adminLocal.copyWith(password: newPasswordController.text);

                          await changePasswordController.updateAdmin(adminLocal);

                          await getStorage.write(
                            StorageKeys.adminDetails,
                            jsonEncode(adminLocal.toJson()),
                          );
                          userDetails = userDetails?.copyWith(admin: adminLocal);
                          setState(() {});
                          Get.back();
                        }
                      }

                      /// operation on Faculty
                      else if (userType == UserType.faculty &&
                          faculty != null &&
                          changePasswordController.facultyList.any(
                            (element) => element.id == faculty!.id,
                          )) {
                        if (faculty!.password != currentPasswordController.text) {
                          showErrorSnackBar(
                            context: context,
                            title: 'Wrong Current Password',
                          );
                        } else {
                          Faculty facultyLocal = changePasswordController.facultyList.firstWhere(
                            (element) => element.id == faculty!.id,
                          );

                          facultyLocal = facultyLocal.copyWith(password: newPasswordController.text);

                          await changePasswordController.updateFaculty(facultyLocal);

                          await getStorage.write(
                            StorageKeys.facultyDetails,
                            jsonEncode(facultyLocal.toJson()),
                          );
                          userDetails = userDetails?.copyWith(faculty: facultyLocal);
                          setState(() {});
                          Get.back();
                        }
                      } else {
                        showErrorSnackBar(
                          context: context,
                          title: 'Something went wrong',
                        );
                      }
                    },
                    child: SubmitButtonHelper(
                      height: Dimens.height80,
                      width: MediaQuery.sizeOf(context).width,
                      child: AppTextTheme.textSize16(
                        label: 'Change Password',
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String getName() {
    if (userType == UserType.admin && admin != null && admin!.name.isNotEmpty) {
      return admin!.name;
    }
    if (userType == UserType.faculty && faculty != null && faculty!.name.isNotEmpty) {
      return faculty!.name;
    }
    return '';
  }
}
