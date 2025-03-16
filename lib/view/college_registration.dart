import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/college_registration_controller.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/form_field_extension.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class CollegeRegistrationView extends StatefulWidget {
  const CollegeRegistrationView({
    super.key,
  });

  @override
  State<CollegeRegistrationView> createState() => _CollegeRegistrationViewState();
}

class _CollegeRegistrationViewState extends State<CollegeRegistrationView> {
  late CollegeRegistrationController collegeRegistrationController;

  /// form fields
  late TextEditingController collegeNameController;
  late TextEditingController emailController;
  late TextEditingController adminNameController;
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
    adminNameController = TextEditingController();
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
      adminNameController.text.isNotEmpty &&
      EmailValidator.validate(emailController.text) &&
      passwordController.text.isNotEmpty &&
      passwordController.text.length >= 6 &&
      passwordRegex.hasMatch(passwordController.text) &&
      mobileNumberController.text.isNotEmpty &&
      locationController.text.isNotEmpty &&
      noOfDepartmentController.text.isNotEmpty &&
      noOfCoursesController.text.isNotEmpty &&
      websiteController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
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
                  errorMessage: '${LabelStrings.collegeName} ${LabelStrings.require}',
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
                  errorMessage: '${LabelStrings.location} ${LabelStrings.require}',
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
                  errorMessage: '${LabelStrings.noOfDepartments} ${LabelStrings.require}',
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
                  errorMessage: '${LabelStrings.noOfCourses} ${LabelStrings.require}',
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
                  errorMessage: '${LabelStrings.website} ${LabelStrings.require}',
                  textInputType: TextInputType.url,
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

            /// admin name text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.name,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterName,
                  controller: adminNameController,
                  isError: clickOnSave && adminNameController.text.isEmpty,
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
                  isError: clickOnSave && (emailController.text.isEmpty || (emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text))),
                  errorMessage: (emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text)) ? LabelStrings.emailIncorrect : '${LabelStrings.email} ${LabelStrings.require}',
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
                  errorMessage: '${LabelStrings.mobileNumber} ${LabelStrings.require}',
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
                  isError: clickOnSave && (passwordController.text.isEmpty || passwordController.text.length < 6 || !passwordRegex.hasMatch(passwordController.text)),
                  errorMessage: !passwordRegex.hasMatch(passwordController.text)
                      ? 'Password must contain at least:- 1 uppercase letter,1 lowercase letter, 1 number, 1 special character'
                      : passwordController.text.length < 6
                          ? 'Password length must at least 6'
                          : '${LabelStrings.password} ${LabelStrings.require}',
                  textInputType: TextInputType.text,
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
            SizedBox(height: Dimens.height60),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                setState(() {
                  clickOnSave = !validateFields();
                });

                if (validateFields()) {
                  collegeRegistrationController.loader(true);
                  College college = College(
                    id: collegeRegistrationController.collegeList.length + 1,
                    name: collegeNameController.text.trim(),
                    email: emailController.text.toLowerCase().trim(),
                    location: locationController.text.trim(),
                    noOfDepartments: noOfDepartmentController.convertToNum(),
                    noOfCourses: noOfCoursesController.convertToNum(),
                    websiteUrl: websiteController.text.trim(),
                  );
                  Admin admin = Admin(
                    id: collegeRegistrationController.adminList.length + 1,
                    name: adminNameController.text.trim(),
                    email: emailController.text.toLowerCase().trim(),
                    password: passwordController.text.trim(),
                    mobileNumber: mobileNumberController.text.trim(),
                    college: college,
                  );

                  /// validation for check the user is already registered or not
                  if (collegeRegistrationController.collegeList.any(
                    (element) => element.name.trim().toLowerCase() == college.name.trim().toLowerCase() && element.email.trim().toLowerCase() == college.email.trim().toLowerCase(),
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'College is already exist',
                    );
                    collegeRegistrationController.loader(false);
                    return;
                  }
                  if (collegeRegistrationController.adminList.any(
                    (element) =>
                        element.name.trim().toLowerCase() == admin.name.trim().toLowerCase() &&
                        element.email.trim().toLowerCase() == admin.email.trim().toLowerCase() &&
                        element.mobileNumber.trim().toLowerCase() == admin.mobileNumber.trim().toLowerCase(),
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Admin is already exist',
                    );
                    collegeRegistrationController.loader(false);
                    return;
                  }
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
                          child: Center(
                            child: Loader(
                              color: AppColors.white,
                            ),
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
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.back();
              },
              child: AppTextTheme.textSize16(
                label: '${LabelStrings.alreadyAccount}?',
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
