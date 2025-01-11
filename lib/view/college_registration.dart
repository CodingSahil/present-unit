import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/college_registration_controller.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/form_field_extension.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class CollegeRegistrationView extends StatefulWidget {
  const CollegeRegistrationView({
    super.key,
  });

  @override
  State<CollegeRegistrationView> createState() =>
      _CollegeRegistrationViewState();
}

class _CollegeRegistrationViewState extends State<CollegeRegistrationView> {
  late CollegeRegistrationController collegeRegistrationController;

  /// form fields
  late TextEditingController collegeNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController mobileNumberController;
  late TextEditingController locationController;
  late TextEditingController noOfDepartmentController;
  late TextEditingController noOfCoursesController;
  late TextEditingController websiteController;

  bool clickOnSave = false;

  @override
  void initState() {
    collegeRegistrationController = Get.find<CollegeRegistrationController>();
    collegeNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    mobileNumberController = TextEditingController();
    locationController = TextEditingController();
    noOfDepartmentController = TextEditingController();
    noOfCoursesController = TextEditingController();
    websiteController = TextEditingController();

    collegeRegistrationController.getCollegeList();
    collegeRegistrationController.getAdminList();

    super.initState();
  }

  bool validateFields() =>
      collegeNameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      EmailValidator.validate(emailController.text) &&
      passwordController.text.isNotEmpty &&
      mobileNumberController.text.isNotEmpty &&
      locationController.text.isNotEmpty &&
      noOfDepartmentController.text.isNotEmpty &&
      noOfCoursesController.text.isNotEmpty &&
      websiteController.text.isNotEmpty;

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
        child: ListView(
          children: [
            /// create account
            AppTextTheme.textSize30(
              label: LabelStrings.createAccount,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.height42),

            /// create account instruction
            AppTextTheme.textSize18(
              label: LabelStrings.createAccountInstruction,
              color: AppColors.black,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.height56),

            /// college name text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.collegeName,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterCollegeName,
                  controller: collegeNameController,
                  isError: clickOnSave && collegeNameController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.collegeName} ${LabelStrings.require}',
                  textInputType: TextInputType.text,
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

            /// location text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.location,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterLocation,
                  controller: locationController,
                  isError: clickOnSave && locationController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.location} ${LabelStrings.require}',
                  textInputType: TextInputType.text,
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

            /// no of dept text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.noOfDepartments,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterNoOfDepartments,
                  controller: noOfDepartmentController,
                  isError: clickOnSave && noOfDepartmentController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.noOfDepartments} ${LabelStrings.require}',
                  textInputType: TextInputType.number,
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

            /// no of dept text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.noOfCourses,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterNoOfCourses,
                  controller: noOfCoursesController,
                  isError: clickOnSave && noOfCoursesController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.noOfCourses} ${LabelStrings.require}',
                  textInputType: TextInputType.number,
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

            /// no of dept text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.website,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterWebsite,
                  controller: websiteController,
                  isError: clickOnSave && websiteController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.website} ${LabelStrings.require}',
                  textInputType: TextInputType.text,
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

            /// admin email text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.email,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterEmail,
                  controller: emailController,
                  isError: clickOnSave &&
                      (emailController.text.isEmpty ||
                          (emailController.text.isNotEmpty &&
                              !EmailValidator.validate(emailController.text))),
                  errorMessage: (emailController.text.isNotEmpty &&
                          !EmailValidator.validate(emailController.text))
                      ? LabelStrings.emailIncorrect
                      : '${LabelStrings.email} ${LabelStrings.require}',
                  textInputType: TextInputType.emailAddress,
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

            /// admin mobile number text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.mobileNumber,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterMobileNumber,
                  controller: mobileNumberController,
                  isError: clickOnSave && mobileNumberController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.mobileNumber} ${LabelStrings.require}',
                  textInputType: TextInputType.phone,
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

            /// admin password text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.password,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterPassword,
                  controller: passwordController,
                  isError: clickOnSave && passwordController.text.isEmpty,
                  errorMessage:
                      '${LabelStrings.password} ${LabelStrings.require}',
                  textInputType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onFieldSubmitted: (value) {
                    setState(() {});
                  },
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

                if (validateFields()) {
                  collegeRegistrationController.loader(true);
                  Admin admin = Admin(
                    id: collegeRegistrationController.adminList.length + 1,
                    email: emailController.text.toLowerCase(),
                    password: passwordController.text,
                    mobileNumber: mobileNumberController.text,
                  );
                  College college = College(
                    id: collegeRegistrationController.collegeList.length + 1,
                    name: collegeNameController.text,
                    email: emailController.text.toLowerCase(),
                    location: locationController.text,
                    noOfDepartments: noOfDepartmentController.convertToNum(),
                    noOfCourses: noOfCoursesController.convertToNum(),
                    websiteUrl: websiteController.text,
                    admin: admin,
                  );
                  await collegeRegistrationController.writeCollegeObject(
                    college: college,
                  );
                  college = College(
                    id: college.id,
                    name: college.name,
                    email: college.email,
                    location: college.location,
                    noOfDepartments: college.noOfDepartments,
                    noOfCourses: college.noOfCourses,
                    websiteUrl: college.websiteUrl,
                  );
                  admin = admin.copyWith(college: college);
                  await collegeRegistrationController.writeAdminObject(
                    admin: admin,
                  );
                  collegeRegistrationController.loader(false);
                  Get.back<bool>(
                    result: true,
                  );
                }
              },
              child: SubmitButtonHelper(
                width: MediaQuery.sizeOf(context).width,
                height: Dimens.height80,
                child: Obx(
                  () => collegeRegistrationController.loader.value
                      ? SizedBox(
                          height: Dimens.height24,
                          width: Dimens.width24,
                          child: Loader(
                            color: AppColors.white,
                          ),
                        )
                      : AppTextTheme.textSize16(
                          label: LabelStrings.signUp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
            SizedBox(height: Dimens.height50),
            AppTextTheme.textSize16(
              label: '${LabelStrings.alreadyAccount}?',
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
