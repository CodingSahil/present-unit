import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';

Future<dynamic> showCommonBottomSheet({
  required BuildContext context,
  required String title,
  required List<BottomSheetSelectionModel> listOfItems,
  required BottomSheetSelectionModel? selectValue,
  required void Function(BottomSheetSelectionModel selectValue) onSubmit,
}) async {
  BottomSheetSelectionModel? selectValueLocal = listOfItems.firstWhereOrNull(
    (element) =>
        element.id == selectValue?.id &&
        element.name.trim().toLowerCase() ==
            selectValue?.name.trim().toLowerCase(),
  );
  listOfItems.length.toString().logOnString('list => ');
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    scrollControlDisabledMaxHeightRatio: 0.8,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => listOfItems.isEmpty
            ? Center(
                child: AppTextTheme.textSize16(
                    label: LabelStrings.noData, color: AppColors.black),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.height28,
                    ),
                    child: AppTextTheme.textSize16(
                      label: title,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Divider(
                    color: AppColors.black.withAlpha(
                      (255 * 0.5).toInt(),
                    ),
                    thickness: 0.5,
                    height: 1,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height28,
                        horizontal: Dimens.width20,
                      ),
                      children: listOfItems
                          .map(
                            (item) => Column(
                              children: [
                                RadioListTile<String>(
                                  value: item.name,
                                  groupValue: selectValueLocal?.name,
                                  activeColor: AppColors.primaryColor,
                                  title: AppTextTheme.textSize12(
                                    label: item.name,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  selected: selectValueLocal?.id == item.id,
                                  onChanged: (value) {
                                    setState(() {
                                      selectValueLocal = item;
                                    });
                                  },
                                ),
                                SizedBox(height: Dimens.height6),
                                // Divider(
                                //   height: 1,
                                //   thickness: 0.5,
                                //   color: AppColors.black.withAlpha(
                                //     (255 * 0.5).toInt(),
                                //   ),
                                // ),
                                // SizedBox(height: Dimens.height6),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (selectValueLocal != null)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        onSubmit(selectValueLocal!);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                            Dimens.radius15,
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimens.width50,
                          vertical: Dimens.height16,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.height16,
                        ),
                        child: AppTextTheme.textSize14(
                          label: 'Submit',
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (isIOS) SizedBox(height: Dimens.height24),
                ],
              ),
      );
    },
  );
  return await Future.value(
    selectValueLocal,
  );
}

Future<dynamic> showCommonBottomSheetWithCheckBox({
  required BuildContext context,
  required String title,
  required List<BottomSheetSelectionModel> listOfItems,
  required List<BottomSheetSelectionModel>? selectValue,
  required void Function(List<BottomSheetSelectionModel> selectValue) onSubmit,
}) async {
  List<BottomSheetSelectionModel>? selectValueLocal = selectValue;
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    scrollControlDisabledMaxHeightRatio: 0.8,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => listOfItems.isEmpty
            ? Center(
                child: AppTextTheme.textSize16(
                    label: LabelStrings.noData, color: AppColors.black),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.height28,
                    ),
                    child: AppTextTheme.textSize16(
                      label: title,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Divider(
                    color: AppColors.black.withAlpha(
                      (255 * 0.5).toInt(),
                    ),
                    thickness: 0.5,
                    height: 1,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height28,
                        horizontal: Dimens.width20,
                      ),
                      children: listOfItems
                          .map(
                            (item) => Column(
                              children: [
                                CheckboxListTile(
                                  value: selectValueLocal != null &&
                                      selectValueLocal!.isNotEmpty &&
                                      selectValueLocal!.any(
                                        (element) => element.id == item.id,
                                      ),
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: AppTextTheme.textSize12(
                                    label: item.name,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  selected: selectValueLocal != null &&
                                      selectValueLocal!.isNotEmpty &&
                                      selectValueLocal!.any(
                                        (element) => element.id == item.id,
                                      ),
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (value) {
                                    if (selectValueLocal != null &&
                                        selectValueLocal!.isNotEmpty) {
                                      if (selectValueLocal!.any(
                                        (element) => element.id == item.id,
                                      )) {
                                        selectValueLocal!.removeWhere(
                                          (element) => element.id == item.id,
                                        );
                                      } else {
                                        selectValueLocal!.add(item);
                                      }
                                    } else {
                                      selectValueLocal = [
                                        item,
                                      ];
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: Dimens.height6),
                                // Divider(
                                //   height: 1,
                                //   thickness: 0.5,
                                //   color: AppColors.black.withAlpha(
                                //     (255 * 0.5).toInt(),
                                //   ),
                                // ),
                                // SizedBox(height: Dimens.height6),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  // if (selectValueLocal != null && selectValueLocal!.isNotEmpty)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onSubmit(selectValueLocal!);
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          Dimens.radius15,
                        ),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimens.width50,
                        vertical: Dimens.height16,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height16,
                      ),
                      child: AppTextTheme.textSize14(
                        label: 'Submit',
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isIOS) SizedBox(height: Dimens.height24),
                ],
              ),
      );
    },
  );
  return await Future.value(
    selectValueLocal,
  );
}

Future<dynamic> showAddEditStudentBottomSheet({
  required BuildContext context,
  required String title,
  required List<Student> listOfItems,
  required Student? selectValue,
  required void Function(Student selectValue) onSubmit,
}) async {
  Student? selectValueLocal = listOfItems.firstWhereOrNull(
    (element) =>
        element.id == selectValue?.id &&
        element.name.trim().toLowerCase() ==
            selectValue?.name.trim().toLowerCase(),
  );
  bool isError = false;
  TextEditingController studentNameController = TextEditingController(
    text: selectValueLocal?.name,
  );
  TextEditingController studentMobileNumberController = TextEditingController(
    text: selectValueLocal?.mobileNumber,
  );
  TextEditingController studentEmailController = TextEditingController(
    text: selectValueLocal?.email,
  );
  TextEditingController studentPasswordController = TextEditingController(
    text: selectValueLocal?.password,
  );

  bool validateFields() =>
      studentNameController.text.isNotEmpty &&
      studentMobileNumberController.text.isNotEmpty &&
      studentMobileNumberController.text.length == 10 &&
      studentEmailController.text.isNotEmpty &&
      EmailValidator.validate(studentEmailController.text) &&
      passwordRegex.hasMatch(studentPasswordController.text);

  Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.height12,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.symmetric(
                vertical: Dimens.height28,
              ),
              child: AppTextTheme.textSize16(
                label: title,
                color: AppColors.primaryColor,
              ),
            ),
            Divider(
              color: AppColors.black.withAlpha(
                (255 * 0.5).toInt(),
              ),
              thickness: 0.5,
              height: 1,
            ),
            SizedBox(
              height: Dimens.height24,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.width50,
                ),
                children: [
                  LabeledTextFormField(
                    controller: studentNameController,
                    hintText: 'Student Name',
                    isError: isError && studentNameController.text.isEmpty,
                  ),
                  SizedBox(height: Dimens.height18),
                  LabeledTextFormField(
                    controller: studentMobileNumberController,
                    hintText: 'Student Mobile Number',
                    textInputType: TextInputType.phone,
                    isError: isError &&
                        (studentMobileNumberController.text.isEmpty ||
                            studentMobileNumberController.text.length < 10),
                    errorMessage: studentMobileNumberController.text.length < 10
                        ? 'Enter Proper Mobile Number'
                        : null,
                  ),
                  SizedBox(height: Dimens.height18),
                  LabeledTextFormField(
                    controller: studentEmailController,
                    hintText: 'Student Email',
                    textInputType: TextInputType.emailAddress,
                    isError: isError &&
                        (studentEmailController.text.isEmpty ||
                            (studentEmailController.text.isNotEmpty &&
                                !EmailValidator.validate(
                                    studentEmailController.text))),
                    errorMessage: (studentEmailController.text.isNotEmpty &&
                            !EmailValidator.validate(
                                studentEmailController.text))
                        ? LabelStrings.emailIncorrect
                        : '${LabelStrings.email} ${LabelStrings.require}',
                  ),
                  SizedBox(height: Dimens.height18),
                  LabeledTextFormField(
                    controller: studentPasswordController,
                    hintText: 'Password',
                    isPasswordField: true,
                    isError: isError &&
                        (studentPasswordController.text.isEmpty ||
                            studentPasswordController.text.length < 6 ||
                            !passwordRegex
                                .hasMatch(studentPasswordController.text)),
                    errorMessage: !passwordRegex
                            .hasMatch(studentPasswordController.text)
                        ? 'Password must contain at least:- 1 uppercase letter,\n1 lowercase letter, 1 number, 1 special character'
                        : studentPasswordController.text.length < 6
                            ? 'Password length must at least 6'
                            : '${LabelStrings.password} ${LabelStrings.require}',
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: Dimens.height36),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        isError = !validateFields();
                      });
                      if (!isError) {
                        Student student = Student(
                          id: listOfItems.isNotEmpty
                              ? listOfItems.length + 1
                              : 1,
                          name: studentNameController.text,
                          mobileNumber: studentMobileNumberController.text,
                          email: studentEmailController.text,
                          password: studentPasswordController.text,
                          course: selectValueLocal != null &&
                                  selectValueLocal.course != null
                              ? selectValueLocal.course
                              : listOfItems.isNotEmpty
                                  ? listOfItems.first.course
                                  : Course.empty(),
                          admin: selectValueLocal != null &&
                                  selectValueLocal.admin != null
                              ? selectValueLocal.admin
                              : listOfItems.isNotEmpty
                                  ? listOfItems.first.admin
                                  : Admin.empty(),
                          college: selectValueLocal != null &&
                                  selectValueLocal.college != null
                              ? selectValueLocal.college
                              : listOfItems.isNotEmpty
                                  ? listOfItems.first.college
                                  : College.empty(),
                        );
                        onSubmit(student);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          Dimens.radius15,
                        ),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.symmetric(
                        // horizontal: Dimens.width50,
                        vertical: Dimens.height16,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height16,
                      ),
                      child: AppTextTheme.textSize14(
                        label: 'Submit',
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isIOS) SizedBox(height: Dimens.height24),
          ],
        ),
      ),
    ),
    backgroundColor: AppColors.white,
  );
  return await Future.value(
    selectValueLocal,
  );
}
