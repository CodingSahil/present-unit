import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';

class TaskListNavigation {
  TaskListNavigation({
    required this.showAppBar,
    required this.taskList,
    this.onEvent,
  });

  final bool showAppBar;
  final List<Tasks> taskList;
  final void Function(List<Tasks> taskList)? onEvent;
}

class TaskListView extends StatefulWidget {
  const TaskListView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late TextEditingController taskInputInDialogController;
  late FocusNode alertDialogTaskFocusNode;

  TaskListNavigation? taskListNavigation;
  List<Tasks> taskList = [];

  @override
  void initState() {
    taskInputInDialogController = TextEditingController();
    alertDialogTaskFocusNode = FocusNode();
    if (widget.arguments != null && widget.arguments is TaskListNavigation) {
      taskListNavigation = widget.arguments as TaskListNavigation;
      if (taskListNavigation!.taskList.isNotEmpty) {
        taskList = taskListNavigation!.taskList;
      }
    }
    super.initState();
  }

  void showAddEditTaskAlertDialog({Tasks? task}) async {
    bool isError = false;
    taskInputInDialogController.text = task?.task ?? '';
    await showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          const Duration(
            milliseconds: 200,
          ),
          () {
            try {
              FocusScope.of(context).requestFocus(alertDialogTaskFocusNode);
            } on Exception catch (e) {
              e.toString().logOnString('Exception => ');
            }
          },
        );
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
              focusNode: alertDialogTaskFocusNode,
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
                      if (task != null) {
                        taskList[task.index] = taskList[task.index].copyWith(
                          task: taskInputInDialogController.text.trim(),
                        );
                      } else {
                        taskList.add(
                          Tasks(
                            task: taskInputInDialogController.text.trim(),
                            completed: false,
                            index: taskList.length,
                          ),
                        );
                      }
                      taskInputInDialogController.clear();
                      if (taskListNavigation != null && taskListNavigation!.onEvent != null) {
                        taskListNavigation!.onEvent!(taskList);
                      }
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
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.height14,
                    horizontal: Dimens.width30,
                  ),
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

  @override
  Widget build(BuildContext context) {
    // '${taskList.map(
    //           (e) => jsonEncode(
    //             e.toJson(),
    //           ),
    //         ).toList()}'
    //     .logOnString('taskList => ');
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: taskListNavigation != null && taskListNavigation!.showAppBar
          ? commonAppBarPreferred(
              label: taskListNavigation!.taskList.isNotEmpty ? 'Edit Tasks' : 'Add Tasks',
              isAdd: false,
            )
          : null,
      body: taskList.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextTheme.textSize16(
                    label: 'No Tasks are added',
                    color: AppColors.lightTextColor,
                  ),
                  SizedBox(height: Dimens.height16),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      showAddEditTaskAlertDialog();
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Dimens.height70,
                      width: Dimens.width180,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          Dimens.radius15,
                        ),
                      ),
                      child: AppTextTheme.textSize16(
                        label: 'Add Task',
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.height16,
                horizontal: Dimens.width20,
              ),
              children: taskList.map(
                (item) {
                  int index = taskList.indexOf(item);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(
                        //   top: index == 0 ? Dimens.height12 : 0,
                        //   bottom: Dimens.height20,
                        // ),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.height16,
                          horizontal: Dimens.width16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            Dimens.radius15,
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
                                setState(() {
                                  if (value != null) {
                                    value.toString().logOnString('value => ');
                                    taskList[index] = taskList[index].copyWith(completed: value);
                                    taskList.map((e) => jsonEncode(e.toJson()),).toList().toString().logOnString('taskList => ');
                                  }
                                });
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
                            SizedBox(width: Dimens.width12),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                showAddEditTaskAlertDialog(
                                  task: item,
                                );
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
                                  taskList.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: AppColors.red,
                                size: Dimens.height38,
                              ),
                            ),
                            SizedBox(width: Dimens.width12),
                          ],
                        ),
                      ),
                      if (index != taskList.length - 1)
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
            ),
      floatingActionButton: taskList.isEmpty
          ? const SizedBox.shrink()
          : FloatingActionButton.extended(
              onPressed: () {
                showAddEditTaskAlertDialog();
              },
              label: AppTextTheme.textSize14(
                label: 'Add New Task',
                color: AppColors.white,
              ),
              backgroundColor: AppColors.primaryColor,
              icon: Icon(
                Icons.add,
                color: AppColors.white,
                size: Dimens.height30,
              ),
            ),
    );
  }
}
