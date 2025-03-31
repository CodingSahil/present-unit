import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/faculty/classes_with_attendance_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/helpers/enum/faculty_enum.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';
import 'package:present_unit/view/faculty/classes/lecture_list_view.dart';
import 'package:present_unit/view/splash_view.dart';

class LectureDetailsView extends StatefulWidget {
  const LectureDetailsView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<LectureDetailsView> createState() => _LectureDetailsViewState();
}

class _LectureDetailsViewState extends State<LectureDetailsView> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late final TextEditingController taskInputInDialogController;
  late final TextEditingController notesController;
  late final ClassesWithAttendanceController classesWithAttendanceController;
  ClassesForAttendanceModel? classesForAttendanceModel;
  List<MentionInNotes> mentionInNotesList = [];
  List<Student> studentList = [];
  int tabIndex = 1;
  UserType userType = UserType.none;
  bool isNotStudent = false;

  @override
  void initState() {
    classesWithAttendanceController = Get.find<ClassesWithAttendanceController>();
    taskInputInDialogController = TextEditingController();
    notesController = TextEditingController();
    tabController = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );

    if (userDetails != null && userDetails!.userType != null && userDetails!.userType! != UserType.none) {
      userType = userDetails!.userType!;
      isNotStudent = userType != UserType.student;
    }

    if (widget.arguments != null && widget.arguments is ClassesForAttendanceModel) {
      classesForAttendanceModel = widget.arguments as ClassesForAttendanceModel;
      if (classesForAttendanceModel != null && classesForAttendanceModel!.mentionInNotesList.isNotEmpty) {
        mentionInNotesList = classesForAttendanceModel!.mentionInNotesList;
      }
      if (classesForAttendanceModel != null && classesForAttendanceModel!.notes != null && classesForAttendanceModel!.notes!.isNotEmpty) {
        notesController.text = classesForAttendanceModel!.notes!;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    classesWithAttendanceController.submitLoader.value = false;
    classesWithAttendanceController.loader.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      animationDuration: const Duration(
        milliseconds: 250,
      ),
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: commonAppBarPreferred(
          label: 'Lecture Details',
          isSave: tabIndex == 0 && isNotStudent,
          saveWidget: Obx(
            () => classesWithAttendanceController.submitLoader.value
                ? Center(
                    child: Loader(
                      color: AppColors.white,
                    ),
                  )
                : Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: Dimens.width44,
                  ),
          ),
          onSave: () async {
            if (classesForAttendanceModel != null) {
              classesWithAttendanceController.submitLoader(true);
              await classesWithAttendanceController.updateLecture(classesForAttendanceModel!);
              classesWithAttendanceController.submitLoader(false);
              setState(() {});
            }
          },
          bottom: TabBar(
            controller: tabController,
            dividerColor: AppColors.white,
            dividerHeight: Dimens.height4,
            onTap: (value) {
              setState(() {
                tabIndex = value;
                if (value != 2) {
                  FocusScope.of(context).unfocus();
                }
              });
            },
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  AssetsPaths.taskTodoSVG,
                  height: Dimens.height50,
                  width: Dimens.width50,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  AssetsPaths.studentsSVG,
                  height: Dimens.height45,
                  width: Dimens.width45,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  AssetsPaths.notesSVG,
                  height: Dimens.height50,
                  width: Dimens.width50,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            taskForLectureDetailsView(),
            attendanceForLectureDetailsView(),
            notesForLectureDetailsView(),
          ],
        ),
      ),
    );
  }

  Future<void> showAddEditTaskAlertDialog({Tasks? task}) async {
    bool isError = false;
    taskInputInDialogController.text = task?.task ?? '';
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setInnerState) => AlertDialog(
            backgroundColor: AppColors.white,
            title: AppTextTheme.textSize16(
              label: 'Add Task',
              color: AppColors.black,
            ),
            content: LabeledTextFormField(
              controller: taskInputInDialogController,
              hintText: '',
              isError: isError,
              errorMessage: isError ? "Enter your task" : '',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  taskInputInDialogController.clear();
                  Navigator.pop(context);
                },
                child: AppTextTheme.textSize16(
                  label: 'Cancel',
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (taskInputInDialogController.text.isEmpty) {
                    setInnerState(() {
                      isError = true;
                    });
                  } else {
                    setInnerState(() {
                      isError = false;
                    });
                    FocusScope.of(context).unfocus();
                    setState(() {
                      if (classesForAttendanceModel != null && classesForAttendanceModel!.tasks != null && classesForAttendanceModel!.tasks!.isNotEmpty) {
                        if (task != null) {
                          classesForAttendanceModel!.tasks![task.index] = classesForAttendanceModel!.tasks![task.index].copyWith(
                            task: taskInputInDialogController.text.trim(),
                          );
                        } else {
                          classesForAttendanceModel!.tasks!.add(
                            Tasks(
                              task: taskInputInDialogController.text.trim(),
                              completed: false,
                              index: classesForAttendanceModel!.tasks!.length,
                            ),
                          );
                        }
                      }
                      taskInputInDialogController.clear();
                    });
                    Navigator.pop(context);
                    showSuccessSnackBar(
                      context: context,
                      title: task != null ? 'Task updated!' : 'Task added!!',
                      durationInMilliseconds: 1200,
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: Dimens.height70,
                  width: Dimens.width160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimens.radius20,
                    ),
                    color: AppColors.primaryColor,
                  ),
                  child: AppTextTheme.textSize16(
                    label: 'Submit',
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    setState(() {});
  }

  Widget taskForLectureDetailsView() {
    return Column(
      children: [
        Expanded(
          child: classesForAttendanceModel != null && classesForAttendanceModel!.tasks != null && classesForAttendanceModel!.tasks!.isNotEmpty
              ? ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.height16,
                    horizontal: Dimens.width20,
                  ),
                  children: classesForAttendanceModel!.tasks!.map(
                    (item) {
                      int index = classesForAttendanceModel!.tasks!.indexOf(item);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimens.height16,
                              horizontal: Dimens.width16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: index == 0 ? Radius.circular(Dimens.radius15) : Radius.zero,
                                topRight: index == 0 ? Radius.circular(Dimens.radius15) : Radius.zero,
                                bottomLeft: index == classesForAttendanceModel!.tasks!.length - 1 ? Radius.circular(Dimens.radius15) : Radius.zero,
                                bottomRight: index == classesForAttendanceModel!.tasks!.length - 1 ? Radius.circular(Dimens.radius15) : Radius.zero,
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: item.completed,
                                  activeColor: AppColors.primaryColor,
                                  shape: CircleBorder(
                                    eccentricity: 0.75,
                                    side: BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  visualDensity: const VisualDensity(
                                    vertical: VisualDensity.minimumDensity,
                                    horizontal: VisualDensity.minimumDensity,
                                  ),
                                  onChanged: (value) {
                                    if (isNotStudent) {
                                      setState(() {
                                        if (value != null) {
                                          classesForAttendanceModel!.tasks![index] = classesForAttendanceModel!.tasks![index].copyWith(completed: value);
                                        }
                                      });
                                    }
                                  },
                                ),
                                SizedBox(width: Dimens.width12),
                                Expanded(
                                  child: AppTextTheme.textSize16(
                                    label: item.task.toString(),
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (isNotStudent) ...[
                                  SizedBox(width: Dimens.width12),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      bool isError = false;
                                      taskInputInDialogController.text = item.task;
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setInnerState) => AlertDialog(
                                              backgroundColor: AppColors.white,
                                              title: AppTextTheme.textSize16(
                                                label: 'Add Task',
                                                color: AppColors.black,
                                              ),
                                              content: LabeledTextFormField(
                                                controller: taskInputInDialogController,
                                                hintText: '',
                                                isError: isError,
                                                errorMessage: isError ? "Enter your task" : '',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    taskInputInDialogController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child: AppTextTheme.textSize16(
                                                    label: 'Cancel',
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () async {
                                                    if (taskInputInDialogController.text.isEmpty) {
                                                      setInnerState(() {
                                                        isError = true;
                                                      });
                                                    } else {
                                                      setInnerState(() {
                                                        isError = false;
                                                      });
                                                      FocusScope.of(context).unfocus();
                                                      if (classesForAttendanceModel != null && classesForAttendanceModel!.tasks != null && classesForAttendanceModel!.tasks!.isNotEmpty) {
                                                        classesForAttendanceModel!.tasks![item.index] = classesForAttendanceModel!.tasks![item.index].copyWith(
                                                          task: taskInputInDialogController.text.trim(),
                                                        );
                                                        '${classesForAttendanceModel!.tasks!.map(
                                                                  (e) => jsonEncode(e.toJson()),
                                                                ).toList()}'
                                                            .logOnString('tasks => ');
                                                        await classesWithAttendanceController.updateLecture(classesForAttendanceModel!);
                                                      }
                                                      taskInputInDialogController.clear();
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                      showSuccessSnackBar(
                                                        context: context,
                                                        title: 'Task updated!',
                                                        durationInMilliseconds: 1200,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: Dimens.height70,
                                                    width: Dimens.width160,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                        Dimens.radius20,
                                                      ),
                                                      color: AppColors.primaryColor,
                                                    ),
                                                    child: Obx(
                                                      () => classesWithAttendanceController.submitLoader.value
                                                          ? const ButtonLoader()
                                                          : AppTextTheme.textSize16(
                                                              label: 'Submit',
                                                              color: AppColors.white,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      AssetsPaths.editSVG,
                                      alignment: Alignment.center,
                                      width: Dimens.width34,
                                      height: Dimens.height34,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimens.width24),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      setState(() {
                                        classesForAttendanceModel!.tasks!.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.red,
                                      size: Dimens.height38,
                                    ),
                                  ),
                                ],
                                SizedBox(width: Dimens.width12),
                              ],
                            ),
                          ),
                          if (index != classesForAttendanceModel!.tasks!.length - 1)
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: AppColors.black.withAlpha(
                                (255 * 0.2).toInt(),
                              ),
                            ),
                        ],
                      );
                    },
                  ).toList(),
                )
              : Center(
                  child: AppTextTheme.textSize12(
                    label: 'No tasks are added',
                  ),
                ),
        ),
        if (isNotStudent)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              bool isError = false;
              log('isError => $isError');
              taskInputInDialogController.text = '';
              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setInnerState) => AlertDialog(
                      backgroundColor: AppColors.white,
                      title: AppTextTheme.textSize16(
                        label: 'Add Task',
                        color: AppColors.black,
                      ),
                      content: LabeledTextFormField(
                        controller: taskInputInDialogController,
                        hintText: '',
                        isError: isError,
                        errorMessage: isError ? "Enter your task" : '',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            taskInputInDialogController.clear();
                            Navigator.pop(context);
                          },
                          child: AppTextTheme.textSize16(
                            label: 'Cancel',
                            color: AppColors.black,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (taskInputInDialogController.text.isEmpty) {
                              setInnerState(() {
                                isError = true;
                              });
                            } else {
                              setInnerState(() {
                                isError = false;
                              });
                              FocusScope.of(context).unfocus();
                              if (classesForAttendanceModel != null && classesForAttendanceModel!.tasks != null && classesForAttendanceModel!.tasks!.isNotEmpty) {
                                classesForAttendanceModel!.tasks!.add(
                                  Tasks(
                                    task: taskInputInDialogController.text.trim(),
                                    completed: false,
                                    index: classesForAttendanceModel!.tasks!.length,
                                  ),
                                );
                                '${classesForAttendanceModel!.tasks!.map(
                                          (e) => jsonEncode(e.toJson()),
                                        ).toList()}'
                                    .logOnString('tasks => ');
                                await classesWithAttendanceController.updateLecture(classesForAttendanceModel!);

                                taskInputInDialogController.clear();
                                setState(() {});
                                Navigator.pop(context);
                                showSuccessSnackBar(
                                  context: context,
                                  title: 'Task added!!',
                                  durationInMilliseconds: 1200,
                                );
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Dimens.height70,
                            width: Dimens.width160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.radius20,
                              ),
                              color: AppColors.primaryColor,
                            ),
                            child: Obx(
                              () => classesWithAttendanceController.submitLoader.value
                                  ? const ButtonLoader()
                                  : AppTextTheme.textSize16(
                                      label: 'Submit',
                                      color: AppColors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(Dimens.radius25),
              ),
              margin: EdgeInsets.symmetric(horizontal: Dimens.width40),
              height: Dimens.height96,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: Dimens.height30,
                  ),
                  SizedBox(width: Dimens.width20),
                  AppTextTheme.textSize14(
                    label: 'Add New Task',
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: Dimens.height40 + (isIOS ? Dimens.height36 : 0)),
      ],
    );
  }

  Widget attendanceForLectureDetailsView() {
    return classesForAttendanceModel != null && classesForAttendanceModel!.studentList.isNotEmpty
        ? GetBuilder<ClassesWithAttendanceController>(
            id: UpdateKeys.updateAttendanceSection,
            builder: (controller) => Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.height16,
                      horizontal: Dimens.width20,
                    ),
                    children: classesForAttendanceModel!.studentList.map(
                      (student) {
                        int index = classesForAttendanceModel!.studentList.indexOf(student);
                        return StudentCardForLecture(
                          index: index,
                          student: student,
                          isNotStudent: isNotStudent,
                          isPresent: classesForAttendanceModel!.presentStudentList != null &&
                              classesForAttendanceModel!.presentStudentList!.isNotEmpty &&
                              classesForAttendanceModel!.presentStudentList!.any(
                                (element) => element.id == student.id,
                              ),
                          isAbsent: classesForAttendanceModel!.absentStudentList != null &&
                              classesForAttendanceModel!.absentStudentList!.isNotEmpty &&
                              classesForAttendanceModel!.absentStudentList!.any(
                                (element) => element.id == student.id,
                              ),
                          isLoggedInStudent: !isNotStudent && classesWithAttendanceController.student != null && classesWithAttendanceController.student!.id == student.id,
                          onPresent: (student) {
                            if (classesForAttendanceModel != null) {
                              List<Student> presentStudentList = classesForAttendanceModel!.presentStudentList ?? [];
                              List<Student> absentStudentList = classesForAttendanceModel!.absentStudentList ?? [];
                              setState(() {
                                if (absentStudentList.isNotEmpty &&
                                    absentStudentList.any(
                                      (element) => element.id == student.id,
                                    )) {
                                  absentStudentList.removeWhere((element) => element.id == student.id);
                                }

                                presentStudentList.add(student);
                                log('presentStudentList in stf => ${presentStudentList.map((e) => jsonEncode(e.toJson())).toList()}');
                                log('absentStudentList in stf => ${absentStudentList.map((e) => jsonEncode(e.toJson())).toList()}');
                                classesForAttendanceModel = classesForAttendanceModel!.copyWith(
                                  presentStudentList: presentStudentList,
                                  absentStudentList: absentStudentList,
                                );
                              });
                            }
                          },
                          onAbsent: (student) {
                            if (classesForAttendanceModel != null) {
                              List<Student> presentStudentList = classesForAttendanceModel!.presentStudentList ?? [];
                              List<Student> absentStudentList = classesForAttendanceModel!.absentStudentList ?? [];
                              setState(() {
                                if (presentStudentList.isNotEmpty &&
                                    presentStudentList.any(
                                      (element) => element.id == student.id,
                                    )) {
                                  presentStudentList.removeWhere((element) => element.id == student.id);
                                }

                                absentStudentList.add(student);
                                log('presentStudentList in stf => ${presentStudentList.map((e) => jsonEncode(e.toJson())).toList()}');
                                log('absentStudentList in stf => ${absentStudentList.map((e) => jsonEncode(e.toJson())).toList()}');
                                classesForAttendanceModel = classesForAttendanceModel!.copyWith(
                                  presentStudentList: presentStudentList,
                                  absentStudentList: absentStudentList,
                                );
                              });
                            }
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
                if (isNotStudent && ((classesForAttendanceModel!.presentStudentList ?? []).isNotEmpty || (classesForAttendanceModel!.absentStudentList ?? []).isNotEmpty)) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      'onTap'.logOnString('');
                      if (classesForAttendanceModel != null) {
                        List<Student> studentList = classesForAttendanceModel!.studentList;
                        List<Student> presentStudentList = classesForAttendanceModel!.presentStudentList ?? [];
                        List<Student> absentStudentList = classesForAttendanceModel!.absentStudentList ?? [];

                        for (var student in studentList) {
                          bool isStudentInPresentList = presentStudentList.any((element) => element.id == student.id);
                          bool isStudentInAbsentList = absentStudentList.any((element) => element.id == student.id);

                          if (!isStudentInPresentList && !isStudentInAbsentList) {
                            absentStudentList.add(student);
                          }
                        }

                        if (classesForAttendanceModel!.absentStudentList != null &&
                            classesForAttendanceModel!.absentStudentList!.isNotEmpty &&
                            absentStudentList.isNotEmpty &&
                            classesForAttendanceModel!.absentStudentList!.length != absentStudentList.length) {
                          classesForAttendanceModel = classesForAttendanceModel!.copyWith(absentStudentList: absentStudentList);
                        }

                        await classesWithAttendanceController.updateLecture(classesForAttendanceModel!);
                        await Future.delayed(const Duration(milliseconds: 200));
                        Get.back<bool>(result: true);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(Dimens.radius25),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: Dimens.width40),
                      height: Dimens.height90,
                      width: MediaQuery.sizeOf(context).width,
                      child: Obx(
                        () => classesWithAttendanceController.submitLoader.value
                            ? const ButtonLoader()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: Dimens.height30,
                                  ),
                                  SizedBox(width: Dimens.width20),
                                  AppTextTheme.textSize15(
                                    label: 'Save Attendance',
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.height40 + (isIOS ? Dimens.height36 : 0)),
                ],
              ],
            ),
          )
        : Center(
            child: AppTextTheme.textSize14(
              label: 'No Students Added',
            ),
          );
  }

  Widget notesForLectureDetailsView() {
    String mentionedStudent;
    int lastIndex = 0;
    return GetBuilder<ClassesWithAttendanceController>(
      id: UpdateKeys.updateNotesSection,
      builder: (controller) => Stack(
        children: [
          if (isNotStudent)
            floatingCustomButton(
              onTap: () async {
                if (classesForAttendanceModel != null && !classesWithAttendanceController.submitLoader.value) {
                  classesForAttendanceModel = classesForAttendanceModel!.copyWith(
                    notes: notesController.text,
                    mentionInNotesList: mentionInNotesList,
                  );
                  await classesWithAttendanceController.updateLecture(classesForAttendanceModel!);
                }
              },
              child: Obx(
                () => classesWithAttendanceController.submitLoader.value
                    ? const ButtonLoader()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: Dimens.height30,
                          ),
                          SizedBox(width: Dimens.width20),
                          AppTextTheme.textSize15(
                            label: 'Save',
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
              ),
              showButton: notesController.text.isNotEmpty,
              isShowIcon: true,
            ),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.height30,
                    horizontal: Dimens.width30,
                  ),
                  child: LabeledTextFormField(
                    controller: notesController,
                    hintText: 'Write notes...',
                    showBorder: false,
                    enable: isNotStudent,
                    maxLines: MediaQuery.sizeOf(context).height.toInt(),
                    onChanged: (value) {
                      int numberOfMention = 0;
                      if (value.isNotEmpty) {
                        for (int i = 0; i < value.length; i++) {
                          if (value[i] == "@") {
                            numberOfMention += 1;
                          }
                        }
                        if (numberOfMention == mentionInNotesList.length) {
                          'all student is mentioned'.logOnString('success');
                        } else {
                          'student is under mentioning'.logOnString('under process');
                        }
                        lastIndex = value.lastIndexOf("@");
                        if (lastIndex != -1) {
                          mentionedStudent = value.substring(lastIndex);
                          Future.delayed(const Duration(milliseconds: 500));
                          searchListQuery(
                            name: mentionedStudent.replaceAll("@", ""),
                            controller: controller,
                          );
                        } else {
                          mentionedStudent = '';
                          studentList = [];
                        }
                      }
                      controller.update([UpdateKeys.updateNotesSection]);
                    },
                    onFieldSubmitted: (value) {
                      controller.update([UpdateKeys.updateNotesSection]);
                    },
                  ),
                ),
              ),
              if (studentList.isNotEmpty)
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: AppColors.black,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.width30,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(Dimens.radius18),
                          ),
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          child: ListView(
                            children: studentList.map(
                              (student) {
                                int index = studentList.indexOf(student);
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    String name = student.name.replaceAll(" ", "_").toLowerCase();
                                    String filteredNotes = notesController.text.substring(0, lastIndex);
                                    filteredNotes += '@$name ';
                                    notesController.text = filteredNotes;
                                    mentionInNotesList.add(
                                      MentionInNotes(
                                        studentDetails: student,
                                        mentionedAs: name,
                                      ),
                                    );
                                    mentionedStudent = '';
                                    studentList = [];
                                    controller.update([UpdateKeys.updateNotesSection]);
                                    name.logOnString('name => ');
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        padding: EdgeInsets.symmetric(
                                          vertical: Dimens.height20,
                                          horizontal: Dimens.width24,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          vertical: Dimens.height16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppTextTheme.textSize15(
                                              label: student.name,
                                              color: AppColors.black,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: AppColors.black.withAlpha(
                                                (255 * 0.5).toInt(),
                                              ),
                                              size: Dimens.height24,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index != studentList.length - 1)
                                        Divider(
                                          height: 1,
                                          thickness: 0.5,
                                          color: AppColors.black.withAlpha(
                                            (255 * 0.25).toInt(),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void searchListQuery({
    required String name,
    required ClassesWithAttendanceController controller,
  }) {
    if (classesForAttendanceModel != null && classesForAttendanceModel!.studentList.isNotEmpty && name.isNotEmpty) {
      studentList = classesForAttendanceModel!.studentList.where((e) => e.name.toLowerCase().contains(name.toLowerCase())).toList();
      controller.update([UpdateKeys.updateNotesSection]);
    }
  }

  Widget floatingCustomButton({
    required void Function() onTap,
    required Widget child,
    required bool showButton,
    bool isShowIcon = false,
  }) {
    return Positioned(
      bottom: Dimens.height75 + (isIOS ? Dimens.height25 : 0),
      right: Dimens.width40,
      child: showButton
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(Dimens.radius25),
                ),
                height: Dimens.height96,
                width: isShowIcon ? Dimens.width260 : Dimens.width160,
                child: child,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class StudentCardForLecture extends StatefulWidget {
  const StudentCardForLecture({
    super.key,
    required this.index,
    required this.student,
    required this.isNotStudent,
    required this.isPresent,
    required this.isAbsent,
    required this.onPresent,
    required this.onAbsent,
    this.isLoggedInStudent = false,
  });

  final int index;
  final Student student;
  final bool isNotStudent;
  final bool isPresent;
  final bool isAbsent;
  final bool isLoggedInStudent;
  final void Function(Student student) onPresent;
  final void Function(Student student) onAbsent;

  @override
  State<StudentCardForLecture> createState() => _StudentCardForLectureState();
}

class _StudentCardForLectureState extends State<StudentCardForLecture> {
  double cardOffset = 0.0;
  double _dragStartX = 0.0;
  StudentStatus studentStatus = StudentStatus.none;

  @override
  void initState() {
    super.initState();
    if (widget.isPresent) {
      studentStatus = StudentStatus.present;
    }
    if (widget.isAbsent) {
      studentStatus = StudentStatus.absent;
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (widget.isNotStudent) {
      _dragStartX = details.globalPosition.dx;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, int index) {
    if (widget.isNotStudent) {
      setState(() {
        cardOffset = details.globalPosition.dx - _dragStartX;
      });
    }
  }

  void _onHorizontalDragEnd(int index, DragEndDetails details) {
    double dragDistance = cardOffset;
    double velocity = details.primaryVelocity ?? 0.0;

    if (widget.isNotStudent) {
      setState(() {
        if (dragDistance > 80 || velocity > 800) {
          'Swiped Right → Present'.logOnString('Student Status => ');
          studentStatus = StudentStatus.present;
          widget.onPresent(widget.student);
        } else if (dragDistance < -80 || velocity < -800) {
          'Swiped Right → Absent'.logOnString('Student Status => ');
          studentStatus = StudentStatus.absent;
          widget.onAbsent(widget.student);
        }
        cardOffset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      transform: Matrix4.translationValues(cardOffset, 0, 0),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onTap: () async {
        //   await showModalBottomSheet(
        //     context: context,
        //     backgroundColor: AppColors.white,
        //     scrollControlDisabledMaxHeightRatio: 0.8,
        //     builder: (context) {
        //       return ConstrainedBox(
        //         constraints: BoxConstraints(
        //           minHeight: MediaQuery.sizeOf(context).height * 0.25,
        //           maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        //         ),
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           spacing: Dimens.height30,
        //           children: [
        //             Padding(
        //               padding: EdgeInsets.only(
        //                 top: Dimens.height30,
        //               ),
        //               child: AppTextTheme.textSize15(
        //                 label: 'Details of ${widget.student.name}',
        //                 color: AppColors.primaryColor,
        //               ),
        //             ),
        //             Divider(
        //               height: 1,
        //               thickness: 0.5,
        //               color: AppColors.black,
        //             ),
        //
        //             /// todo : add student details
        //           ],
        //         ),
        //       );
        //     },
        //   );
        // },
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details, widget.index),
        onHorizontalDragEnd: (details) => _onHorizontalDragEnd(widget.index, details),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.height20,
            horizontal: Dimens.width24,
          ),
          margin: EdgeInsets.only(
            bottom: Dimens.height20,
          ),
          decoration: BoxDecoration(
            color: studentStatus == StudentStatus.present
                ? AppColors.green.withAlpha(
                    (255 * 0.2).toInt(),
                  )
                : studentStatus == StudentStatus.absent
                    ? AppColors.red.withAlpha(
                        (255 * 0.2).toInt(),
                      )
                    : AppColors.white,
            borderRadius: BorderRadius.circular(
              Dimens.radius18,
            ),
            border: Border.all(
              width: 1,
              color: widget.isLoggedInStudent ? AppColors.primaryColor : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppTextTheme.textSize16(
                    label: (widget.index + 1).toString(),
                    color: AppColors.black,
                  ),
                  SizedBox(width: Dimens.width50),
                  AppTextTheme.textSize16(
                    label: widget.student.name.toString(),
                    color: AppColors.black,
                  ),
                  const Spacer(),
                  AppTextTheme.textSize15(
                    label: widget.student.gender.toLowerCase() == 'male'
                        ? 'M'
                        : widget.student.gender.toLowerCase() == 'female'
                            ? 'F'
                            : '',
                    color: AppColors.black,
                  ),
                  // SvgPicture.asset(
                  //   AssetsPaths.informationSVG,
                  //   height: Dimens.height32,
                  //   width: Dimens.width32,
                  //   colorFilter: ColorFilter.mode(
                  //     AppColors.black.withAlpha((255 * 0.6).toInt()),
                  //     BlendMode.srcIn,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: Dimens.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VerticalTitleValueComponent(
                    title: 'Email',
                    value: widget.student.email,
                    titleSize: 10,
                    valueSize: 13,
                  ),
                  VerticalTitleValueComponent(
                    title: 'Mobile Number',
                    value: widget.student.mobileNumber,
                    isAtEnd: true,
                    isCall: true,
                    titleSize: 10,
                    valueSize: 13,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
