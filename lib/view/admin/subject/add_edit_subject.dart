import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/add_edit_course_controller.dart';
import 'package:present_unit/controller/admin/add_edit_subject_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/bottom-sheet/bottom_sheet.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/form_field_extension.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';
import 'package:present_unit/models/subject/subject_model.dart';

class AddEditSubjectView extends StatefulWidget {
  const AddEditSubjectView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditSubjectView> createState() => _AddEditSubjectViewState();
}

class _AddEditSubjectViewState extends State<AddEditSubjectView> {
  late AddEditCourseController addEditCourseController;
  late AddEditSubjectController addEditSubjectController;

  /// Text Editing Controller's
  late TextEditingController subjectNameController;
  late TextEditingController subjectCreditController;
  late TextEditingController semesterController;
  late TextEditingController subjectCodeController;

  /// todo :- make feature of Material of Subject

  SubjectNavigation? subjectNavigation;
  Course? selectedCourse;

  bool isError = false;

  @override
  void initState() {
    super.initState();
    addEditCourseController = Get.find<AddEditCourseController>();
    addEditSubjectController = Get.find<AddEditSubjectController>();
    subjectNameController = TextEditingController();
    subjectCreditController = TextEditingController();
    semesterController = TextEditingController();
    subjectCodeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await addEditCourseController.getListOfCourse();
      },
    );

    if (widget.arguments != null && widget.arguments is SubjectNavigation) {
      subjectNavigation = widget.arguments as SubjectNavigation;
      if (subjectNavigation != null) {
        subjectNameController.text = subjectNavigation!.name;
        subjectCreditController.text = subjectNavigation!.credit.toString();
        semesterController.text = subjectNavigation!.semester.toString();
        subjectCodeController.text = subjectNavigation!.subjectCode;
        if (addEditCourseController.courseList.any(
          (element) => element.id == subjectNavigation!.course.id,
        )) {
          selectedCourse = addEditCourseController.courseList.singleWhere(
            (element) => element.id == subjectNavigation!.course.id,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: widget.arguments != null ? 'Edit Subject' : 'Add Subject',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.height60,
          horizontal: Dimens.width40,
        ),
        child: ListView(
          children: [
            LabeledTextFormField(
              controller: subjectNameController,
              hintText: 'Enter Subject Name',
              isError: isError && subjectNameController.text.isEmpty,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: subjectCreditController,
              hintText: 'Enter Subject Credit',
              isError: isError &&
                  (subjectCreditController.text.isEmpty ||
                      subjectCreditController.convertToNum() == 0 ||
                      subjectCreditController.convertToNum() > 10),
              errorMessage:
                  isError && subjectCreditController.convertToNum() > 10
                      ? 'Enter proper credit'
                      : null,
              onChanged: (value) {
                setState(() {});
              },
              textInputType: TextInputType.number,
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: semesterController,
              hintText: 'Enter Semester',
              isError: isError &&
                  (semesterController.text.isEmpty ||
                      semesterController.convertToNum() == 0 ||
                      semesterController.convertToNum() > 10),
              errorMessage: isError && semesterController.convertToNum() > 10
                  ? 'Enter proper semester'
                  : null,
              onChanged: (value) {
                setState(() {});
              },
              textInputType: TextInputType.number,
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: subjectCodeController,
              hintText: 'Enter Subject Code',
              isError: isError && subjectCodeController.text.isEmpty,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.height30),
            StatefulBuilder(builder: (context, setInnerState) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await showCommonBottomSheet(
                    context: context,
                    title: 'Courses',
                    listOfItems: addEditCourseController.courseList
                        .map(
                          (e) => BottomSheetSelectionModel(
                            id: e.id,
                            name: e.name,
                          ),
                        )
                        .toList(),
                    selectValue: selectedCourse != null
                        ? BottomSheetSelectionModel(
                            id: selectedCourse!.id,
                            name: selectedCourse!.name,
                          )
                        : null,
                    onSubmit: (selectValue) {
                      setState(() {
                        selectedCourse = addEditCourseController.courseList.any(
                          (element) => element.id == selectValue.id,
                        )
                            ? addEditCourseController.courseList.singleWhere(
                                (element) => element.id == selectValue.id,
                              )
                            : null;
                      });
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimens.radius16,
                    ),
                    border: Border.all(
                      color: isError && selectedCourse == null
                          ? AppColors.red
                          : AppColors.black,
                      width: isError && selectedCourse == null ? 1 : 0.75,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.height24,
                    horizontal: Dimens.width30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextTheme.textSize14(
                        label: selectedCourse != null
                            ? selectedCourse!.name
                            : 'Select Course',
                        color: AppColors.black.withAlpha(
                          (255 * 0.7).toInt(),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.black,
                        size: Dimens.height36,
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: Dimens.height60),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                setState(() {
                  isError = !addEditSubjectController.validateFields(
                    subjectName: subjectNameController.text,
                    subjectCredit: subjectCreditController.convertToNum(),
                    semester: semesterController.convertToNum(),
                    subjectCode: subjectCodeController.text,
                    isAdminFilled: addEditSubjectController.admin != null,
                    isCourseFilled: selectedCourse != null,
                  );
                  isError.toString().logOnString('isError');
                });
                if (isError) {
                  return;
                }
                addEditSubjectController.submitLoader(true);

                if (subjectNavigation != null) {
                  Course? course = selectedCourse;
                  if (addEditSubjectController.admin != null) {
                    addEditSubjectController.admin =
                        addEditSubjectController.admin!.copyWith(
                      college: College.empty(),
                    );
                  }
                  Subject subject = Subject(
                    documentID: subjectNavigation!.documentID,
                    id: subjectNavigation!.id,
                    name: subjectNameController.text.trim(),
                    credit: subjectCreditController.convertToNum(),
                    semester: semesterController.convertToNum(),
                    subjectCode: subjectCodeController.text.trim(),
                    course: course,
                    admin: addEditSubjectController.admin,
                  );
                  await addEditSubjectController.updateSubjectData(
                    subject: subject,
                  );
                } else {
                  if (addEditSubjectController.admin != null) {
                    addEditSubjectController.admin =
                        addEditSubjectController.admin!.copyWith(
                      college: College.empty(),
                    );
                  }
                  log('message');
                  Course? course = selectedCourse;

                  Subject subject = Subject(
                    documentID:
                        '${subjectNameController.text.trim().toLowerCase().replaceAll(RegExp(r'[.\s]'), '')}${addEditSubjectController.admin != null && addEditSubjectController.admin!.id != -1000 ? '_${addEditSubjectController.admin!.id}_${addEditSubjectController.admin!.name.trim().toLowerCase().replaceAll(RegExp(r'[.\s]'), '')}' : 'temp${addEditSubjectController.globalSubjectList.length + 1}'}',
                    id: addEditSubjectController.globalSubjectList.length + 1,
                    name: subjectNameController.text.trim(),
                    credit: subjectCreditController.convertToNum(),
                    semester: semesterController.convertToNum(),
                    subjectCode: subjectCodeController.text.trim(),
                    course: course,
                    admin: addEditSubjectController.admin,
                  );
                  if (course != null) {
                    await addEditSubjectController.writeSubjectData(
                      subject: subject,
                    );
                  }
                }
                addEditSubjectController.submitLoader(false);
                Get.back(
                  result: true,
                );
              },
              child: SubmitButtonHelper(
                height: MediaQuery.sizeOf(context).height * 0.05,
                width: MediaQuery.sizeOf(context).width,
                child: Obx(
                  () => addEditSubjectController.submitLoader.value
                      ? const ButtonLoader()
                      : AppTextTheme.textSize16(
                          label: subjectNavigation != null &&
                                  widget.arguments != null
                              ? LabelStrings.update
                              : LabelStrings.add,
                          color: AppColors.white,
                        ),
                ),
              ),
            ),
            SizedBox(height: Dimens.height30),
          ],
        ),
      ),
    );
  }
}
