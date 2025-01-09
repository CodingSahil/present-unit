import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/college_registration_controller.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

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
  late TextEditingController confirmPasswordController;
  late TextEditingController locationController;
  late TextEditingController noOfDepartmentController;
  late TextEditingController noOfCoursesController;
  late TextEditingController websiteController;

  @override
  void initState() {
    collegeRegistrationController = Get.find<CollegeRegistrationController>();
    collegeNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    mobileNumberController = TextEditingController();
    locationController = TextEditingController();
    noOfDepartmentController = TextEditingController();
    noOfCoursesController = TextEditingController();
    websiteController = TextEditingController();
    super.initState();
  }

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
                ),
              ],
            ),
            SizedBox(height: Dimens.height36),

            /// admin password text-form-field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize16(
                  label: LabelStrings.confirmPassword,
                  color: AppColors.black,
                ),
                SizedBox(height: Dimens.height8),
                LabeledTextFormField(
                  hintText: LabelStrings.enterConfirmPassword,
                  controller: confirmPasswordController,
                ),
              ],
            ),
            SizedBox(height: Dimens.height60),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                collegeRegistrationController.loader(true);
                await Future.delayed(
                  const Duration(
                    seconds: 3,
                  ),
                  () {
                    collegeRegistrationController.loader(false);
                  },
                );
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
