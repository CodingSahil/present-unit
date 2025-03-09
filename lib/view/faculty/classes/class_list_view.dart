import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/faculty/classes_with_attendance_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/date-time-convert/date_time_conversion.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/routes/routes.dart';

class ClassListForAttendanceView extends StatefulWidget {
  const ClassListForAttendanceView({super.key});

  @override
  State<ClassListForAttendanceView> createState() => _ClassListForAttendanceViewState();
}

class _ClassListForAttendanceViewState extends State<ClassListForAttendanceView> with SingleTickerProviderStateMixin {
  late final ClassesWithAttendanceController classesWithAttendanceController;
  late final slideController = SlidableController(this);

  @override
  void initState() {
    classesWithAttendanceController = Get.find<ClassesWithAttendanceController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await classesWithAttendanceController.getClassesList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Class List',
        isBack: false,
        onTap: () async {
          dynamic result = await Get.toNamed(Routes.addEditClassesWithAttendanceView);
          if (result is bool && result == true) {
            await classesWithAttendanceController.getClassesList();
          }
        },
      ),
      body: Obx(
        () {
          return classesWithAttendanceController.loader.value
              ? Center(
                  child: Loader(
                    color: AppColors.primaryColor,
                  ),
                )
              : GetBuilder<ClassesWithAttendanceController>(
                  id: UpdateKeys.updateLectureList,
                  builder: (controller) => classesWithAttendanceController.classesForAttendanceModel.isEmpty
                      ? Center(
                          child: AppTextTheme.textSize14(
                            label: 'No Data',
                            color: AppColors.black,
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimens.height24,
                            horizontal: Dimens.width30,
                          ),
                          hitTestBehavior: HitTestBehavior.translucent,
                          children: classesWithAttendanceController.classesForAttendanceModel.map(
                            (lecture) {
                              DateTime startTime = DateTimeConversion.convertStringToDateTime(lecture.startingTime);
                              DateTime endTime = DateTimeConversion.convertStringToDateTime(lecture.endingTime);
                              int differenceInHours = endTime.difference(startTime).inHours;
                              int differenceInMinutes = endTime.difference(startTime).inMinutes;
                              log('difference => ${DateTimeConversion.convertMinutesToHours(differenceInMinutes)}');
                              RxBool deleteLoader = false.obs;
                              return StatefulBuilder(
                                builder: (context, setInnerState) {
                                  return Slidable(
                                    controller: slideController,
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      extentRatio: 0.3,
                                      openThreshold: 0.1,
                                      closeThreshold: 0.1,
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            deleteLoader.value = true;
                                            await classesWithAttendanceController.deleteLecture(
                                              lecture.documentID,
                                            );
                                            classesWithAttendanceController.update([
                                              UpdateKeys.updateLectureList,
                                            ]);
                                            deleteLoader.value = false;
                                            slideController.close();
                                          },
                                          icon: Icons.delete,
                                          backgroundColor: AppColors.red,
                                          foregroundColor: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            Dimens.radius15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimens.height12,
                                        horizontal: Dimens.width30,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(
                                          Dimens.radius15,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: Dimens.height16,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              VerticalTitleValueComponent(
                                                title: 'Subject',
                                                value: lecture.subject.name,
                                              ),
                                              GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () async {
                                                  Get.toNamed(
                                                    Routes.addEditClassesWithAttendanceView,
                                                    arguments: lecture,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      AssetsPaths.simpleEditSVG,
                                                      alignment: Alignment.center,
                                                      width: Dimens.width28,
                                                      height: Dimens.height28,
                                                      colorFilter: ColorFilter.mode(
                                                        AppColors.black,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    SizedBox(width: Dimens.width12),
                                                    AppTextTheme.textSize14(
                                                      label: 'Edit',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              VerticalTitleValueComponent(
                                                title: 'Class',
                                                value: lecture.classDetails.name,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  AppTextTheme.textSize12(
                                                    label: 'Lecture Date',
                                                    color: AppColors.black.withAlpha(
                                                      (255 * 0.6).toInt(),
                                                    ),
                                                  ),
                                                  SizedBox(width: Dimens.width8),
                                                  AppTextTheme.textSize16(
                                                    label: lecture.lectureDate,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppTextTheme.textSize12(
                                                    label: 'Starting Time',
                                                    color: AppColors.black.withAlpha(
                                                      (255 * 0.6).toInt(),
                                                    ),
                                                  ),
                                                  SizedBox(width: Dimens.width8),
                                                  AppTextTheme.textSize16(
                                                    label: lecture.startingTime,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  AppTextTheme.textSize12(
                                                    label: 'Ending Time',
                                                    color: AppColors.black.withAlpha(
                                                      (255 * 0.6).toInt(),
                                                    ),
                                                  ),
                                                  SizedBox(width: Dimens.width8),
                                                  AppTextTheme.textSize16(
                                                    label: lecture.endingTime,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              VerticalTitleValueComponent(
                                                title: 'No. of Students',
                                                value: lecture.studentList.length.toString(),
                                              ),
                                              if (lecture.tasks != null && lecture.tasks!.isNotEmpty)
                                                VerticalTitleValueComponent(
                                                  title: 'No. of Tasks',
                                                  value: lecture.tasks?.length.toString() ?? '',
                                                  isAtCenter: true,
                                                ),
                                              VerticalTitleValueComponent(
                                                title: 'Duration of Lecture',
                                                value: DateTimeConversion.convertMinutesToHours(differenceInMinutes),
                                                isAtEnd: true,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ).toList(),
                        ),
                );
        },
      ),
    );
  }
}

class VerticalTitleValueComponent extends StatelessWidget {
  const VerticalTitleValueComponent({
    super.key,
    required this.title,
    required this.value,
    this.isAtEnd = false,
    this.isAtCenter = false,
  });

  final String title;
  final String value;
  final bool isAtEnd;
  final bool isAtCenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isAtEnd
          ? CrossAxisAlignment.end
          : isAtCenter
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
      children: [
        AppTextTheme.textSize12(
          label: title,
          color: AppColors.black.withAlpha(
            (255 * 0.6).toInt(),
          ),
        ),
        SizedBox(height: Dimens.height4),
        AppTextTheme.textSize16(
          label: value,
          color: AppColors.black,
        ),
      ],
    );
  }
}

class HorizontalTitleValueComponent extends StatelessWidget {
  const HorizontalTitleValueComponent({
    super.key,
    required this.title,
    required this.value,
    this.isAtEnd = false,
    this.isAtCenter = false,
  });

  final String title;
  final String value;
  final bool isAtEnd;
  final bool isAtCenter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isAtEnd
          ? MainAxisAlignment.end
          : isAtCenter
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppTextTheme.textSize12(
          label: title,
          color: AppColors.black.withAlpha(
            (255 * 0.6).toInt(),
          ),
        ),
        SizedBox(height: Dimens.height8),
        AppTextTheme.textSize16(
          label: value,
          color: AppColors.black,
        ),
      ],
    );
  }
}
