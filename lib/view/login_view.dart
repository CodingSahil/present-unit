import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/login_controller.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/common_models/authentication_classes.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/splash_view.dart';

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
    loginController = Get.find<LoginController>();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await loginController.getAdminList();
        await loginController.getFacultyList();
        await loginController.getStudentList();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    loginController.submitLoader(false);
    loginController.loader(false);
    super.dispose();
  }

  bool validateFields() => emailController.text.isNotEmpty && EmailValidator.validate(emailController.text) && passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Obx(
        () => loginController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : Container(
                alignment: Alignment.center,
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).height * 0.04,
                  horizontal: MediaQuery.sizeOf(context).width * 0.09,
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.175,
                    ),
                    AppTextTheme.textSize30(
                      label: LabelStrings.loginHere,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: Dimens.height20),
                    AppTextTheme.textSize18(
                      label: LabelStrings.loginInstruction,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
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
                          isError: clickOnSave && (emailController.text.isEmpty || (emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text))),
                          errorMessage:
                              (emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text)) ? LabelStrings.emailIncorrect : '${LabelStrings.email} ${LabelStrings.require}',
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
                          isPasswordField: true,
                          onChanged: (value) {
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    // SizedBox(height: Dimens.height36),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     AppTextTheme.textSize16(
                    //       label: LabelStrings.forgotPassword,
                    //       color: AppColors.primaryColor,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: Dimens.height60),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        setState(() {
                          clickOnSave = !validateFields();
                        });

                        if (validateFields()) {
                          loginController.submitLoader(true);
                          await loginController.getAdminList(
                            isLoaderRequire: false,
                          );
                          await loginController.getFacultyList(
                            isLoaderRequire: false,
                          );
                          await loginController.getStudentList(
                            isLoaderRequire: false,
                          );

                          (loginController.studentList.isNotEmpty &&
                              loginController.studentList.any(
                                    (element) =>
                                (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                    element.password?.trim() == passwordController.text.trim(),
                              )).toString().logOnString('student');

                          /// admin
                          if (loginController.adminList.isNotEmpty &&
                              loginController.adminList.any(
                                (element) =>
                                    (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                    element.password.trim() == passwordController.text.trim(),
                              )) {
                            Admin admin = loginController.adminList.firstWhere(
                              (element) =>
                                  (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                  element.password.trim() == passwordController.text.trim(),
                            );

                            loginController.submitLoader(true);
                            await loginController.getStorage.write(
                              StorageKeys.adminDetails,
                              jsonEncode(
                                admin.toJson(),
                              ),
                            );
                            await loginController.getStorage.write(
                              StorageKeys.userType,
                              UserType.admin.toString(),
                            );

                            userDetails = UserDetails(
                              admin: admin,
                              faculty: null,
                              student: null,
                              userType: UserType.admin,
                            );

                            await Future.delayed(
                              const Duration(
                                seconds: 1,
                              ),
                            );
                            loginController.submitLoader(false);
                            emailController.clear();
                            passwordController.clear();
                            Get.offAllNamed(Routes.adminDashboard);
                          }

                          /// faculty
                          else if (loginController.facultyList.isNotEmpty &&
                              loginController.facultyList.any(
                                (element) =>
                                    (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                    element.password.trim() == passwordController.text.trim(),
                              )) {
                            Faculty faculty = loginController.facultyList.firstWhere(
                              (element) =>
                                  (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                  element.password.trim() == passwordController.text.trim(),
                            );

                            loginController.submitLoader(true);
                            await loginController.getStorage.write(
                              StorageKeys.facultyDetails,
                              jsonEncode(
                                faculty.toJson(),
                              ),
                            );
                            await loginController.getStorage.write(
                              StorageKeys.userType,
                              UserType.faculty.toString(),
                            );

                            userDetails = UserDetails(
                              admin: null,
                              faculty: faculty,
                              student: null,
                              userType: UserType.faculty,
                            );

                            await Future.delayed(
                              const Duration(
                                seconds: 1,
                              ),
                            );
                            loginController.submitLoader(false);
                            emailController.clear();
                            passwordController.clear();
                            Get.offAllNamed(Routes.facultyDashboard);
                          }

                          /// student
                          else if (loginController.studentList.isNotEmpty &&
                              loginController.studentList.any(
                                (element) =>
                                    (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                    element.password?.trim() == passwordController.text.trim(),
                              )) {
                            Student student = loginController.studentList.firstWhere(
                              (element) =>
                                  (element.email.toLowerCase().trim() == emailController.text.toLowerCase().trim() || element.mobileNumber.trim() == emailController.text.trim()) &&
                                  element.password?.trim() == passwordController.text.trim(),
                            );

                            loginController.submitLoader(true);
                            await loginController.getStorage.write(
                              StorageKeys.studentDetails,
                              jsonEncode(
                                student.toJson(),
                              ),
                            );
                            await loginController.getStorage.write(
                              StorageKeys.userType,
                              UserType.student.toString(),
                            );

                            userDetails = UserDetails(
                              admin: null,
                              faculty: null,
                              student: student,
                              userType: UserType.student,
                            );

                            await Future.delayed(
                              const Duration(
                                seconds: 1,
                              ),
                            );
                            loginController.submitLoader(false);
                            emailController.clear();
                            passwordController.clear();
                            Get.offAllNamed(Routes.studentDashboardView);
                          } else {
                            showErrorSnackBar(
                              context: context,
                              title: 'User doesn\'t exist',
                            );
                          }
                          loginController.submitLoader(false);
                        }
                      },
                      child: SubmitButtonHelper(
                        width: MediaQuery.sizeOf(context).width,
                        height: Dimens.height80,
                        child: Obx(
                          () => loginController.submitLoader.value
                              ? SizedBox(
                                  height: Dimens.height24,
                                  width: Dimens.width24,
                                  child: Center(
                                    child: Loader(
                                      color: AppColors.white,
                                    ),
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
