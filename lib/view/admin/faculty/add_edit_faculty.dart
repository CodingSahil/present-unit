import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/controller/admin/add_edit_faculty_controller.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/controller/admin/subject_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/bottom-sheet/bottom_sheet.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/get_new_id.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';
import 'package:present_unit/models/subject/subject_model.dart';

class AddEditFacultyView extends StatefulWidget {
  const AddEditFacultyView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditFacultyView> createState() => _AddEditFacultyViewState();
}

class _AddEditFacultyViewState extends State<AddEditFacultyView> {
  late GetStorage getStorage;
  late AddEditFacultyController addEditFacultyController;
  late CourseController courseController;
  late SubjectController subjectController;

  late TextEditingController facultyNameController;
  late TextEditingController facultyEmailController;
  late TextEditingController facultyMobileNumberController;
  late TextEditingController facultyPasswordController;

  FacultyNavigation? facultyNavigation;
  Admin? admin;
  List<Course>? selectedCourseList;
  List<Subject>? selectedSubjectList;

  bool isError = false;

  @override
  void initState() {
    super.initState();
    getStorage = GetStorage();
    addEditFacultyController = Get.find<AddEditFacultyController>();
    courseController = Get.find<CourseController>();
    subjectController = Get.find<SubjectController>();

    facultyNameController = TextEditingController();
    facultyEmailController = TextEditingController();
    facultyMobileNumberController = TextEditingController();
    facultyPasswordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await courseController.getListOfCourse();
        await subjectController.getListOfSubject();
        await addEditFacultyController.getListOfFaculty();
        var adminDetails = getStorage.read(StorageKeys.adminDetails);
        admin = Admin.fromJson(jsonDecode(adminDetails),'');
      },
    );

    if (widget.arguments != null && widget.arguments is FacultyNavigation) {
      facultyNavigation = widget.arguments as FacultyNavigation;
      if (facultyNavigation != null) {
        facultyNameController.text = facultyNavigation!.name;
        facultyEmailController.text = facultyNavigation!.email;
        facultyMobileNumberController.text = facultyNavigation!.mobileNumber;
        facultyPasswordController.text = facultyNavigation!.password;
        if (facultyNavigation!.subject.isNotEmpty &&
            subjectController.subjectList.any(
              (element) => facultyNavigation!.subject.any(
                (elementInner) => element.id == elementInner.id,
              ),
            )) {
          selectedSubjectList = subjectController.subjectList
              .where(
                (element) => facultyNavigation!.subject.any(
                  (elementInner) => element.id == elementInner.id,
                ),
              )
              .toList();
        }
        if (facultyNavigation!.course.isNotEmpty &&
            courseController.courseList.any(
              (element) => facultyNavigation!.course.any(
                (elementInner) => element.id == elementInner.id,
              ),
            )) {
          selectedCourseList = courseController.courseList
              .where(
                (element) => facultyNavigation!.course.any(
                  (elementInner) => element.id == elementInner.id,
                ),
              )
              .toList();
        }
      }
    }
  }

  bool validateFields() =>
      facultyNameController.text.isNotEmpty &&
      facultyEmailController.text.isNotEmpty &&
      EmailValidator.validate(
        facultyEmailController.text,
      ) &&
      facultyMobileNumberController.text.isNotEmpty &&
      facultyMobileNumberController.text.length == 10 &&
      facultyPasswordController.text.isNotEmpty &&
      facultyPasswordController.text.length >= 6 &&
      passwordRegex.hasMatch(
        facultyPasswordController.text,
      ) &&
      selectedCourseList != null &&
      selectedCourseList!.isNotEmpty &&
      selectedSubjectList != null &&
      selectedSubjectList!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: widget.arguments != null && facultyNavigation != null ? 'Edit Faculty' : 'Add Faculty',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.height60,
          horizontal: Dimens.width40,
        ),
        child: ListView(
          children: [
            LabeledTextFormField(
              controller: facultyNameController,
              hintText: 'Enter Faculty Name',
              isError: isError && facultyNameController.text.isEmpty,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: facultyEmailController,
              hintText: 'Enter Email',
              isError: isError &&
                  (facultyEmailController.text.isEmpty ||
                      !EmailValidator.validate(
                        facultyEmailController.text,
                      )),
              errorMessage: isError &&
                      facultyEmailController.text.isNotEmpty &&
                      !EmailValidator.validate(
                        facultyEmailController.text,
                      )
                  ? 'Enter Proper Email'
                  : null,
              textInputType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: facultyMobileNumberController,
              hintText: 'Faculty Mobile Number',
              isError: isError && (facultyMobileNumberController.text.isEmpty || facultyMobileNumberController.text.length < 10),
              errorMessage: isError && facultyMobileNumberController.text.length < 10 ? 'Enter proper Mobile number' : null,
              onChanged: (value) {
                setState(() {});
              },
              textInputType: TextInputType.phone,
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: facultyPasswordController,
              hintText: 'Enter Password',
              isPasswordField: true,
              isError: isError &&
                  (facultyPasswordController.text.isEmpty ||
                      facultyPasswordController.text.length <= 6 ||
                      !passwordRegex.hasMatch(
                        facultyPasswordController.text,
                      )),
              errorMessage: !passwordRegex.hasMatch(facultyPasswordController.text)
                  ? 'Password must contain at least:- 1 uppercase letter,\n1 lowercase letter, 1 number, 1 special character'
                  : facultyPasswordController.text.length < 6
                      ? 'Password length must at least 6'
                      : '${LabelStrings.password} ${LabelStrings.require}',
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.height30),
            StatefulBuilder(builder: (context, setInnerState) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await showCommonBottomSheetWithCheckBox(
                    context: context,
                    title: 'Courses',
                    listOfItems: courseController.courseList
                        .map(
                          (e) => BottomSheetSelectionModel(
                            id: e.id,
                            name: e.name,
                          ),
                        )
                        .toList(),
                    selectValue: selectedCourseList != null && selectedCourseList!.isNotEmpty
                        ? selectedCourseList!
                            .map(
                              (e) => BottomSheetSelectionModel(
                                id: e.id,
                                name: e.name,
                              ),
                            )
                            .toList()
                        : [],
                    onSubmit: (selectValue) {
                      setState(() {
                        selectedCourseList = courseController.courseList.any(
                          (element) => selectValue.any(
                            (elementInner) => element.id == elementInner.id,
                          ),
                        )
                            ? courseController.courseList
                                .where(
                                  (element) => selectValue.any(
                                    (elementInner) => element.id == elementInner.id,
                                  ),
                                )
                                .toList()
                            : null;
                        subjectController.getListOfSubjectAccordingToSelectedCourse(
                          courseIDs: selectedCourseList
                                  ?.map(
                                    (e) => e.id,
                                  )
                                  .toList() ??
                              [],
                        );
                        selectedSubjectList = [];
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
                      color: isError && selectedCourseList != null && selectedCourseList!.isEmpty ? AppColors.red : AppColors.black.withAlpha((255 * 0.5).toInt()),
                      width: isError && selectedCourseList != null && selectedCourseList!.isEmpty ? 1 : 0.75,
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
                        label: selectedCourseList != null && selectedCourseList!.isNotEmpty
                            ? selectedCourseList!
                                .map(
                                  (e) => e.name,
                                )
                                .join(', ')
                            : 'Select Course',
                        color: selectedCourseList != null && selectedCourseList!.isNotEmpty
                            ? AppColors.black
                            : AppColors.black.withAlpha(
                                (255 * 0.5).toInt(),
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
            SizedBox(height: Dimens.height30),
            StatefulBuilder(builder: (context, setInnerState) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await showCommonBottomSheetWithCheckBox(
                    context: context,
                    title: 'Subjects',
                    listOfItems: subjectController.subjectList
                        .map(
                          (e) => BottomSheetSelectionModel(
                            id: e.id,
                            name: e.name,
                          ),
                        )
                        .toList(),
                    selectValue: selectedSubjectList != null && selectedSubjectList!.isNotEmpty
                        ? selectedSubjectList!
                            .map(
                              (e) => BottomSheetSelectionModel(
                                id: e.id,
                                name: e.name,
                              ),
                            )
                            .toList()
                        : [],
                    onSubmit: (selectValue) {
                      setState(() {
                        selectedSubjectList = subjectController.subjectList.any(
                          (element) => selectValue.any(
                            (elementInner) => element.id == elementInner.id,
                          ),
                        )
                            ? subjectController.subjectList
                                .where(
                                  (element) => selectValue.any(
                                    (elementInner) => element.id == elementInner.id,
                                  ),
                                )
                                .toList()
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
                      color: isError && selectedSubjectList != null && selectedSubjectList!.isEmpty ? AppColors.red : AppColors.black.withAlpha((255 * 0.5).toInt()),
                      width: isError && selectedSubjectList != null && selectedSubjectList!.isEmpty ? 1 : 0.75,
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
                        label: selectedSubjectList != null && selectedSubjectList!.isNotEmpty
                            ? selectedSubjectList!
                                .map(
                                  (e) => e.name,
                                )
                                .join(', ')
                            : 'Select Subject',
                        color: selectedSubjectList != null && selectedSubjectList!.isNotEmpty
                            ? AppColors.black
                            : AppColors.black.withAlpha(
                                (255 * 0.5).toInt(),
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
                  isError = !validateFields();
                });
                if (isError) {
                  return;
                }
                addEditFacultyController.submitLoader(true);

                if (facultyNavigation != null) {
                  if (admin != null) {
                    admin = admin!.copyWith(
                      college: College.empty(),
                    );
                  }
                  Faculty faculty = Faculty(
                    documentID: facultyNavigation!.documentID,
                    id: facultyNavigation!.id,
                    name: facultyNameController.text.trim(),
                    email: facultyEmailController.text.trim(),
                    mobileNumber: facultyMobileNumberController.text.trim(),
                    password: facultyPasswordController.text.trim(),
                    admin: admin,
                    courseList: selectedCourseList,
                    subjectList: selectedSubjectList,
                  );
                  if (addEditFacultyController.facultyList.any(
                    (element) => element.email.toLowerCase() == faculty.email.toLowerCase(),
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Faculty\'s Email ID is already exist',
                    );
                    addEditFacultyController.submitLoader(false);
                    return;
                  }
                  if (addEditFacultyController.globalFacultyList.any(
                    (element) => element.mobileNumber == faculty.mobileNumber,
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Faculty\'s Mobile Number is already exist',
                    );
                    addEditFacultyController.submitLoader(false);
                    return;
                  }
                  await addEditFacultyController.updateFacultyData(
                    faculty: faculty,
                  );
                } else {
                  if (admin != null) {
                    admin = admin!.copyWith(
                      college: College.empty(),
                    );
                  }

                  Faculty faculty = Faculty(
                    documentID:
                        '${facultyNameController.text.trim().toLowerCase().replaceAll(RegExp(r'[.\s]'), '')}${admin != null && admin!.id != -1000 ? '_${addEditFacultyController.globalFacultyList.length + 1}_${admin!.name.trim().toLowerCase().replaceAll(RegExp(r'[.\s]'), '')}' : 'temp${addEditFacultyController.globalFacultyList.length + 1}'}',
                    id: getNewID(
                      addEditFacultyController.globalFacultyList
                          .map(
                            (e) => e.id,
                          )
                          .toList(),
                    ),
                    name: facultyNameController.text.trim(),
                    email: facultyEmailController.text.trim(),
                    mobileNumber: facultyMobileNumberController.text.trim(),
                    password: facultyPasswordController.text.trim(),
                    admin: admin,
                    courseList: selectedCourseList,
                    subjectList: selectedSubjectList,
                  );
                  if (addEditFacultyController.facultyList.any(
                    (element) => element.email.toLowerCase() == faculty.email.toLowerCase(),
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Faculty\'s Email ID is already exist',
                    );
                    addEditFacultyController.submitLoader(false);
                    return;
                  }
                  if (addEditFacultyController.globalFacultyList.any(
                    (element) => element.mobileNumber == faculty.mobileNumber,
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Faculty\'s Mobile Number is already exist',
                    );
                    addEditFacultyController.submitLoader(false);
                    return;
                  }
                  await addEditFacultyController.writeFacultyData(
                    faculty: faculty,
                  );
                }
                addEditFacultyController.submitLoader(false);
                Get.back<bool>(
                  result: true,
                );
              },
              child: SubmitButtonHelper(
                height: MediaQuery.sizeOf(context).height * 0.05,
                width: MediaQuery.sizeOf(context).width,
                child: Obx(
                  () => addEditFacultyController.submitLoader.value
                      ? const ButtonLoader()
                      : AppTextTheme.textSize16(
                          label: facultyNavigation != null && widget.arguments != null ? LabelStrings.update : LabelStrings.add,
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
