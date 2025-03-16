import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/add_edit_course_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/form_field_extension.dart';
import 'package:present_unit/helpers/get_new_id.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';

class AddEditCourseView extends StatefulWidget {
  const AddEditCourseView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditCourseView> createState() => _AddEditCourseViewState();
}

class _AddEditCourseViewState extends State<AddEditCourseView> {
  late AddEditCourseController addEditCourseController;
  late TextEditingController courseNameController;
  late TextEditingController courseDurationController;

  CourseNavigation? courseNavigation;

  bool isError = false;

  @override
  void initState() {
    super.initState();
    addEditCourseController = Get.find<AddEditCourseController>();
    courseNameController = TextEditingController();
    courseDurationController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await addEditCourseController.getListOfCourse();
      },
    );

    if (widget.arguments != null && widget.arguments is CourseNavigation) {
      courseNavigation = widget.arguments as CourseNavigation;
      if (courseNavigation != null) {
        courseNameController.text = courseNavigation!.name;
        courseDurationController.text = courseNavigation!.duration;
      }
    }
  }

  @override
  void dispose() {
    addEditCourseController.submitLoader.value = false;
    isError = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: widget.arguments != null ? LabelStrings.editCourse : LabelStrings.addCourse,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.height60,
          horizontal: Dimens.width40,
        ),
        child: ListView(
          children: [
            LabeledTextFormField(
              controller: courseNameController,
              hintText: LabelStrings.enterCourseName,
              isError: isError && courseNameController.text.isEmpty,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.height30),
            LabeledTextFormField(
              controller: courseDurationController,
              hintText: LabelStrings.enterCourseDuration,
              isError: isError && (courseDurationController.text.isEmpty || courseDurationController.convertToNum() == 0 || courseDurationController.convertToNum() > 10),
              errorMessage: isError && courseDurationController.convertToNum() > 10 ? LabelStrings.enterProperDuration : null,
              onChanged: (value) {
                setState(() {});
              },
              textInputType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            SizedBox(height: Dimens.height60),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                setState(() {
                  isError = !addEditCourseController.validateFields(
                    name: courseNameController.text,
                    duration: courseDurationController.convertToNum(),
                  );
                });
                if (isError) {
                  return;
                }
                addEditCourseController.submitLoader(true);

                dynamic storedData = addEditCourseController.getStorage.read(StorageKeys.adminDetails);
                if (courseNavigation != null) {
                  Admin? admin = courseNavigation!.admin;
                  if (admin != null) {
                    admin = admin.copyWith(
                      college: College.empty(),
                    );
                  }
                  Course course = Course(
                    id: courseNavigation!.id,
                    name: courseNameController.text.trim(),
                    duration: courseDurationController.convertToNum(),
                    documentID: courseNavigation!.documentID,
                    admin: admin,
                  );

                  if (addEditCourseController.globalCourseList.any(
                    (element) => element.name.toLowerCase() == course.name.toLowerCase(),
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Course is already exist!',
                    );
                    addEditCourseController.submitLoader(false);
                    return;
                  }
                  await addEditCourseController.updateCourseData(
                    course: course,
                  );
                } else {
                  Admin admin = storedData != null && storedData.toString().isNotEmpty
                      ? Admin.fromJson(
                          jsonDecode(storedData.toString()),'',
                        )
                      : Admin.empty();
                  Course course = Course(
                    id: getNewID(addEditCourseController.globalCourseList
                        .map(
                          (e) => e.id,
                        )
                        .toList()),
                    name: courseNameController.text.trim(),
                    duration: courseDurationController.convertToNum(),
                    documentID: '${courseNameController.text.trim().replaceAll(RegExp(r'[.\s]'), '')}${admin.id != -1000 ? '_${admin.id}' : ''}_${admin.email.split("@").first.replaceAll(
                          ".",
                          "",
                        )}',
                    admin: admin,
                  );

                  /// if course is already exist in list , college specific
                  if (addEditCourseController.courseList.any(
                    (element) => element.name.toLowerCase() == course.name.toLowerCase(),
                  )) {
                    showErrorSnackBar(
                      context: context,
                      title: 'Course is already exist!',
                    );
                    addEditCourseController.submitLoader(false);
                    return;
                  }

                  if (addEditCourseController.courseList.length == admin.college.noOfCourses) {
                    showErrorSnackBar(
                      context: context,
                      title: 'You reached your limit of entering course',
                    );
                    addEditCourseController.submitLoader(false);
                    return;
                  }

                  await addEditCourseController.writeCourseData(
                    course: course,
                  );
                }
                addEditCourseController.submitLoader(false);
                Get.back(
                  result: true,
                );
              },
              child: SubmitButtonHelper(
                height: MediaQuery.sizeOf(context).height * 0.05,
                width: MediaQuery.sizeOf(context).width,
                child: Obx(
                  () => addEditCourseController.submitLoader.value
                      ? const ButtonLoader()
                      : AppTextTheme.textSize16(
                          label: courseNavigation != null && widget.arguments != null ? LabelStrings.update : LabelStrings.add,
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
