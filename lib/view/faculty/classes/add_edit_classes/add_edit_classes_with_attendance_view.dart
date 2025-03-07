import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/class_list_controller.dart';
import 'package:present_unit/controller/admin/subject_controller.dart';
import 'package:present_unit/controller/faculty/classes_with_attendance_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/bottom-sheet/bottom_sheet.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/faculty/classes/add_edit_classes/task_list_view.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditClassesWithAttendanceView extends StatefulWidget {
  const AddEditClassesWithAttendanceView({super.key});

  @override
  State<AddEditClassesWithAttendanceView> createState() => _AddEditClassesWithAttendanceViewState();
}

class _AddEditClassesWithAttendanceViewState extends State<AddEditClassesWithAttendanceView> {
  late final ClassesWithAttendanceController classesWithAttendanceController;
  List<Tasks> tasks = [];
  Faculty? faculty;
  BottomSheetSelectionModel? selectedClassList;
  BottomSheetSelectionModel? selectedSubjectList;

  @override
  void initState() {
    classesWithAttendanceController = Get.find<ClassesWithAttendanceController>();
    if (userDetails != null && userDetails!.faculty != null) {
      faculty = userDetails!.faculty!;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await classesWithAttendanceController.getClassesList();
        await classesWithAttendanceController.getListOfClassListStudent();
        await classesWithAttendanceController.getListOfSubject();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarPreferred(
        label: 'Add Edit Classes',
        isAdd: false,
      ),
      body: Obx(
        () => classesWithAttendanceController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.width30,
                  vertical: Dimens.height36,
                ),
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Class',
                        listOfItems: classesWithAttendanceController.classList
                            .map(
                              (e) => BottomSheetSelectionModel(
                                id: e.id,
                                name: e.name,
                              ),
                            )
                            .toList(),
                        selectValue: selectedClassList,
                        onSubmit: (selectValue) {
                          setState(() {
                            selectedClassList = selectValue;
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
                          color: AppColors.black,
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height24,
                        horizontal: Dimens.width30,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextTheme.textSize14(
                            label: selectedClassList?.name ?? 'Select Class',
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
                  ),
                  SizedBox(height: Dimens.height36),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Subject',
                        listOfItems: classesWithAttendanceController.subjectList
                            .map(
                              (e) => BottomSheetSelectionModel(
                                id: e.id,
                                name: e.name,
                              ),
                            )
                            .toList(),
                        selectValue: selectedSubjectList,
                        onSubmit: (selectValue) {
                          setState(() {
                            selectedSubjectList = selectValue;
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
                          color: AppColors.black,
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height24,
                        horizontal: Dimens.width30,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextTheme.textSize14(
                            label: selectedSubjectList?.name ?? 'Select Subject',
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
                  ),
                  SizedBox(height: Dimens.height36),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      Get.toNamed(
                        Routes.taskListView,
                        arguments: TaskListNavigation(
                          showAppBar: true,
                          taskList: tasks
                              .map(
                                (e) => Tasks(
                                  task: e.task,
                                  completed: e.completed,
                                  index: e.index,
                                ),
                              )
                              .toList(),
                          onEvent: (taskList) {
                            setState(() {
                              tasks = taskList;
                              tasks.map((e) => jsonEncode(e.toJson(),),).toList().toString().logOnString('tasks in main screen => ');
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.radius16,
                        ),
                        border: Border.all(
                          color: AppColors.black,
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height24,
                        horizontal: Dimens.width30,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextTheme.textSize14(
                            label: tasks.isNotEmpty ? '${tasks.length} is added' : 'Add Tasks',
                            color: AppColors.black.withAlpha(
                              (255 * 0.7).toInt(),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: AppColors.black,
                            size: Dimens.height36,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
