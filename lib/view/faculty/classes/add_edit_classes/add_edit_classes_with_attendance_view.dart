import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/faculty/classes_with_attendance_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/bottom-sheet/bottom_sheet.dart';
import 'package:present_unit/helper-widgets/buttons/field_with_click_event.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/date-time-convert/date_time_conversion.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/get_new_id.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';
import 'package:present_unit/models/subject/subject_model.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/faculty/classes/add_edit_classes/task_list_view.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditClassesWithAttendanceView extends StatefulWidget {
  const AddEditClassesWithAttendanceView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditClassesWithAttendanceView> createState() => _AddEditClassesWithAttendanceViewState();
}

class _AddEditClassesWithAttendanceViewState extends State<AddEditClassesWithAttendanceView> {
  late final ClassesWithAttendanceController classesWithAttendanceController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateOfLectureController;
  late final TextEditingController startTimeOfLectureController;
  late final TextEditingController endTimeOfLectureController;

  ///
  List<Tasks> tasks = [];
  Faculty? faculty;
  BottomSheetSelectionModel? selectedClassList;
  BottomSheetSelectionModel? selectedSubjectList;
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool isError = false;
  ClassesForAttendanceModel? classesForAttendanceModel;

  @override
  void initState() {
    classesWithAttendanceController = Get.find<ClassesWithAttendanceController>();
    descriptionController = TextEditingController();
    dateOfLectureController = TextEditingController();
    startTimeOfLectureController = TextEditingController();
    endTimeOfLectureController = TextEditingController();
    selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    );
    if (userDetails != null && userDetails!.faculty != null) {
      faculty = userDetails!.faculty!;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await classesWithAttendanceController.getClassesList();
        await classesWithAttendanceController.getListOfClassListStudent();
        await classesWithAttendanceController.getListOfSubject();

        if (widget.arguments != null && widget.arguments is ClassesForAttendanceModel) {
          classesForAttendanceModel = widget.arguments as ClassesForAttendanceModel;

          if (classesForAttendanceModel != null) {
            if (classesForAttendanceModel!.description != null && classesForAttendanceModel!.description!.isNotEmpty) {
              descriptionController.text = classesForAttendanceModel!.description!;
            }
            if (classesForAttendanceModel!.lectureDate.isNotEmpty) {
              dateOfLectureController.text = classesForAttendanceModel!.lectureDate;
              selectedDate = DateTimeConversion.convertStringToDate(classesForAttendanceModel!.lectureDate);
            }
            if (classesForAttendanceModel!.startingTime.isNotEmpty) {
              startTimeOfLectureController.text = classesForAttendanceModel!.startingTime;
              selectedStartTime = DateTimeConversion.convertStringToTime(classesForAttendanceModel!.startingTime);
            }
            if (classesForAttendanceModel!.endingTime.isNotEmpty) {
              endTimeOfLectureController.text = classesForAttendanceModel!.endingTime;
              selectedEndTime = DateTimeConversion.convertStringToTime(classesForAttendanceModel!.endingTime);
            }
            if (classesForAttendanceModel!.tasks != null && classesForAttendanceModel!.tasks!.isNotEmpty) {
              tasks = classesForAttendanceModel!.tasks!;
            }
            ClassListModel selectionForClass = classesWithAttendanceController.classList.singleWhere(
              (element) => element.id == classesForAttendanceModel!.classDetails.id,
            );
            selectedClassList = BottomSheetSelectionModel(
              id: selectionForClass.id,
              name: selectionForClass.name,
            );
            Subject selectionForSubject = classesWithAttendanceController.subjectList.singleWhere(
              (element) => element.id == classesForAttendanceModel!.subject.id,
            );
            selectedSubjectList = BottomSheetSelectionModel(
              id: selectionForSubject.id,
              name: selectionForSubject.name,
            );
          }
        }
      },
    );
    super.initState();
  }

  bool validateFields() =>
      selectedClassList != null &&
      selectedSubjectList != null &&
      tasks.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      selectedDate != null &&
      dateOfLectureController.text.isNotEmpty &&
      selectedStartTime != null &&
      startTimeOfLectureController.text.isNotEmpty &&
      selectedEndTime != null &&
      endTimeOfLectureController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: widget.arguments != null && widget.arguments is ClassesForAttendanceModel ? 'Edit Lecture' : 'Add Lecture',
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
                  /// select class
                  FieldWithClickEventHelper(
                    label: selectedClassList?.name ?? 'Select Class',
                    isValueFilled: selectedClassList != null && selectedClassList!.name.isNotEmpty,
                    isError: isError,
                    errorMessage: 'Select Class',
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Class',
                        listOfItems: classesWithAttendanceController.classList
                            .where(
                              (element) => faculty != null && faculty!.courseList != null && faculty!.courseList!.any((elementInner) => elementInner.id == element.course?.id),
                            )
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
                  ),
                  SizedBox(height: Dimens.height36),

                  /// select subject
                  FieldWithClickEventHelper(
                    label: selectedSubjectList?.name ?? 'Select Subject',
                    isValueFilled: selectedSubjectList != null && selectedSubjectList!.name.isNotEmpty,
                    isError: isError,
                    errorMessage: 'Select Subject',
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Subject',
                        listOfItems: classesWithAttendanceController.subjectList
                            .where((element) {
                              ClassListModel temp = classesWithAttendanceController.classList.singleWhere((element) => element.id == selectedClassList?.id);
                              return temp.course?.id == element.course?.id;
                            })
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
                  ),
                  SizedBox(height: Dimens.height36),

                  /// tasks
                  FieldWithClickEventHelper(
                    label: tasks.isNotEmpty ? '${tasks.length} ${tasks.length > 1 ? 'Tasks' : 'Task'} is added' : 'Add Tasks',
                    isValueFilled: tasks.isNotEmpty,
                    roundedIcon: Icons.keyboard_arrow_right,
                    isError: isError,
                    errorMessage: 'Select Task',
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
                              tasks
                                  .map(
                                    (e) => jsonEncode(
                                      e.toJson(),
                                    ),
                                  )
                                  .toList()
                                  .toString()
                                  .logOnString('tasks in main screen => ');
                            });
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimens.height36),

                  /// description
                  LabeledTextFormField(
                    controller: descriptionController,
                    hintText: 'Description',
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 4,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimens.width20,
                      vertical: Dimens.height20,
                    ),
                  ),
                  SizedBox(height: Dimens.height36),

                  /// select date

                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      if (selectedDate != null) {
                        selectedDate!.difference(DateTime.now()).inDays.toString().logOnString('difference => ');
                      }
                      DateTime? result = await showDatePicker(
                        context: context,
                        firstDate: selectedDate != null && selectedDate!.difference(DateTime.now()).inDays < 0 ? selectedDate! : DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                        currentDate: selectedDate,
                        initialDate: selectedDate,
                      );
                      if (result != null) {
                        selectedDate = result;
                        if (selectedDate != null) {
                          dateOfLectureController.text = DateTimeConversion.convertDateIntoString(selectedDate!);
                        }
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.radius16,
                        ),
                        border: Border.all(
                          color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                          width: 0.5,
                        ),
                      ),
                      child: LabeledTextFormField(
                        controller: dateOfLectureController,
                        hintText: 'Select Lecture Date',
                        enable: false,
                        suffix: Icon(
                          Icons.calendar_month_rounded,
                          size: Dimens.height32,
                          color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.height36),

                  /// select time
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            selectedStartTime = await showTimePicker(
                              context: context,
                              initialTime: selectedStartTime ?? TimeOfDay.now(),
                            );
                            if (selectedStartTime != null) {
                              startTimeOfLectureController.text = DateTimeConversion.convertTimeIntoString(selectedStartTime!);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.radius16,
                              ),
                              border: Border.all(
                                color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                                width: 0.5,
                              ),
                            ),
                            child: LabeledTextFormField(
                              controller: startTimeOfLectureController,
                              hintText: 'Select Start Time',
                              enable: false,
                              suffix: Icon(
                                Icons.access_time_rounded,
                                size: Dimens.height32,
                                color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimens.width20),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            selectedEndTime = await showTimePicker(
                              context: context,
                              initialTime: selectedEndTime ?? TimeOfDay.now(),
                            );
                            if (selectedEndTime != null) {
                              endTimeOfLectureController.text = DateTimeConversion.convertTimeIntoString(selectedEndTime!);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.radius16,
                              ),
                              border: Border.all(
                                color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                                width: 0.5,
                              ),
                            ),
                            child: LabeledTextFormField(
                              controller: endTimeOfLectureController,
                              hintText: 'Select End Time',
                              enable: false,
                              suffix: Icon(
                                Icons.access_time_rounded,
                                size: Dimens.height32,
                                color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.height36),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      setState(() {
                        isError = !validateFields();
                      });
                      if (isError) return;

                      String documentID =
                          '${selectedSubjectList?.name.replaceAll("-", "_").replaceAll(" ", "_")}_${DateTimeConversion.convertDateIntoString(selectedDate!).replaceAll("-", "_")}_${userDetails?.faculty?.name.replaceAll(" ", "_")}';
                      classesForAttendanceModel = ClassesForAttendanceModel(
                        documentID: documentID,
                        id: classesWithAttendanceController.globalClassesForAttendanceModel.isNotEmpty
                            ? int.parse(getNewID(classesWithAttendanceController.globalClassesForAttendanceModel.map((e) => e.id).toList()).toString())
                            : 1,
                        faculty: faculty ?? Faculty.empty(),
                        subject: classesWithAttendanceController.subjectList.singleWhere(
                          (element) => element.id == selectedSubjectList?.id,
                        ),
                        college: faculty?.admin?.college ?? College.empty(),
                        studentList: classesWithAttendanceController.classList
                                .singleWhere(
                                  (element) => element.id == selectedClassList?.id,
                                )
                                .studentList ??
                            [],
                        classDetails: classesWithAttendanceController.classList.singleWhere(
                          (element) => element.id == selectedClassList?.id,
                        ),
                        lectureDate: dateOfLectureController.text,
                        startingTime: startTimeOfLectureController.text,
                        endingTime: endTimeOfLectureController.text,
                        tasks: tasks,
                        description: descriptionController.text,
                      );

                      if (widget.arguments != null && widget.arguments is ClassesForAttendanceModel && classesForAttendanceModel != null) {
                        DateTime lectureDateForAttendance = DateTimeConversion.convertStringToDate(classesForAttendanceModel!.lectureDate);
                        TimeOfDay startingTimeForAttendance = DateTimeConversion.convertStringToTime(classesForAttendanceModel!.startingTime);
                        TimeOfDay endingTimeForAttendance = DateTimeConversion.convertStringToTime(classesForAttendanceModel!.endingTime);

                        if (classesWithAttendanceController.classesForAttendanceModel.any((element) {
                          int index = classesWithAttendanceController.classesForAttendanceModel.indexOf(element);

                          DateTime lectureDateTemp = DateTimeConversion.convertStringToDate(element.lectureDate);
                          TimeOfDay startingTimeTemp = DateTimeConversion.convertStringToTime(element.startingTime);
                          TimeOfDay endingTimeTemp = DateTimeConversion.convertStringToTime(element.endingTime);

                          bool isLectureDateSame =
                              lectureDateForAttendance.day == lectureDateTemp.day && lectureDateForAttendance.month == lectureDateTemp.month && lectureDateForAttendance.year == lectureDateTemp.year;
                          bool isLectureInBetween = checkSameLectureTiming(
                            index: index,
                            startTimeFromList: startingTimeTemp,
                            endTimeFromList: endingTimeTemp,
                            newStartTime: startingTimeForAttendance,
                            newEndTime: endingTimeForAttendance,
                          );

                          return element.id != classesForAttendanceModel!.id &&
                              element.faculty.id == classesForAttendanceModel!.faculty.id &&
                              element.subject.id == classesForAttendanceModel!.subject.id &&
                              element.classDetails.id == classesForAttendanceModel!.classDetails.id &&
                              isLectureDateSame &&
                              isLectureInBetween &&
                              element.isLectureCompleted == classesForAttendanceModel!.isLectureCompleted;
                        })) {
                          showErrorSnackBar(
                            context: context,
                            title: 'A lecture is already scheduled for this date and time for the class',
                          );
                          return;
                        } else {
                          await classesWithAttendanceController.updateLecture(classesForAttendanceModel!);
                          Get.back(
                            result: true,
                          );
                        }
                      } else if (classesForAttendanceModel != null) {
                        DateTime lectureDateForAttendance = DateTimeConversion.convertStringToDate(classesForAttendanceModel!.lectureDate);
                        TimeOfDay startingTimeForAttendance = DateTimeConversion.convertStringToTime(classesForAttendanceModel!.startingTime);
                        TimeOfDay endingTimeForAttendance = DateTimeConversion.convertStringToTime(classesForAttendanceModel!.endingTime);

                        if (classesWithAttendanceController.classesForAttendanceModel.any((element) {
                          int index = classesWithAttendanceController.classesForAttendanceModel.indexOf(element);

                          DateTime lectureDateTemp = DateTimeConversion.convertStringToDate(element.lectureDate);
                          TimeOfDay startingTimeTemp = DateTimeConversion.convertStringToTime(element.startingTime);
                          TimeOfDay endingTimeTemp = DateTimeConversion.convertStringToTime(element.endingTime);

                          bool isLectureDateSame =
                              lectureDateForAttendance.day == lectureDateTemp.day && lectureDateForAttendance.month == lectureDateTemp.month && lectureDateForAttendance.year == lectureDateTemp.year;
                          bool isLectureInBetween = checkSameLectureTiming(
                            index: index,
                            startTimeFromList: startingTimeTemp,
                            endTimeFromList: endingTimeTemp,
                            newStartTime: startingTimeForAttendance,
                            newEndTime: endingTimeForAttendance,
                          );

                          return element.id != classesForAttendanceModel!.id &&
                              element.faculty.id == classesForAttendanceModel!.faculty.id &&
                              element.subject.id == classesForAttendanceModel!.subject.id &&
                              element.classDetails.id == classesForAttendanceModel!.classDetails.id &&
                              isLectureDateSame &&
                              isLectureInBetween &&
                              element.isLectureCompleted == classesForAttendanceModel!.isLectureCompleted;
                        })) {
                          showErrorSnackBar(context: context, title: 'A lecture is already scheduled for this date and time for the class');
                          return;
                        } else {
                          // await classesWithAttendanceController.addLecture(classesForAttendanceModel!);
                          // Get.back(
                          //   result: true,
                          // );
                        }
                      } else {
                        showErrorSnackBar(
                          context: context,
                          title: 'Something went wrong',
                        );
                      }
                    },
                    child: SubmitButtonHelper(
                      width: MediaQuery.sizeOf(context).width,
                      height: Dimens.height80,
                      child: Obx(
                        () => classesWithAttendanceController.submitLoader.value
                            ? const ButtonLoader()
                            : AppTextTheme.textSize14(
                                label: widget.arguments != null && widget.arguments is ClassesForAttendanceModel ? 'Edit Lecture' : 'Add Lecture',
                                color: AppColors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  bool checkSameLectureTiming({
    required int index,
    required TimeOfDay startTimeFromList,
    required TimeOfDay endTimeFromList,
    required TimeOfDay newStartTime,
    required TimeOfDay newEndTime,
  }) {
    '$index\nstartTimeFromList => $startTimeFromList\nendTimeFromList => $endTimeFromList\nnewStartTime => $newStartTime\nnewEndTime => $newEndTime'.logOnString('$index => ');
    if (newStartTime.isAtSameTimeAs(startTimeFromList) && newEndTime.isAtSameTimeAs(endTimeFromList)) {
      'Same Day and time'.logOnString('isAtSameTimeAs');
      return true;
    }

    /// case 1 :-
    /// fixed time 9:00 to 10:00
    /// current time 9:15 to 10:15
    if (newStartTime.isAfter(startTimeFromList) && newEndTime.isAfter(endTimeFromList) && newStartTime.isBefore(endTimeFromList)) {
      'First Case'.logOnString('');
      return true;
    }

    /// case 2
    /// fixed time 9:00 to 10:00
    /// current time 8:45 to 9:45
    if (newStartTime.isBefore(startTimeFromList) && newEndTime.isBefore(endTimeFromList) && newEndTime.isAfter(startTimeFromList)) {
      'Second Case'.logOnString('');
      return true;
    }

    /// case 3
    /// fixed time 9:00 to 10:00
    /// current time 9:01 to 9:59
    if (newStartTime.isAfter(startTimeFromList) && newEndTime.isBefore(endTimeFromList)) {
      'Third Case'.logOnString('');
      return true;
    }

    return false;
  }
}
