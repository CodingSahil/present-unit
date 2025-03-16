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
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassListForAttendanceView extends StatefulWidget {
  const ClassListForAttendanceView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<ClassListForAttendanceView> createState() => _ClassListForAttendanceViewState();
}

class _ClassListForAttendanceViewState extends State<ClassListForAttendanceView> {
  late final ClassesWithAttendanceController classesWithAttendanceController;

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
        isBack: widget.arguments != null && widget.arguments is bool && (widget.arguments is bool) == true,
        onTap: () async {
          dynamic result = await Get.toNamed(Routes.addEditClassesWithAttendanceView);
          if (result is bool && result == true) {
            await classesWithAttendanceController.getClassesList();
            await Future.delayed(const Duration(milliseconds: 500));
            classesWithAttendanceController.update([UpdateKeys.updateLectureList]);
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
                              return ClassesWithAttendanceView(
                                lecture: lecture,
                                classesWithAttendanceController: classesWithAttendanceController,
                                onRefresh: () async {
                                  await classesWithAttendanceController.getClassesList();
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  classesWithAttendanceController.update([UpdateKeys.updateLectureList]);
                                },
                                onDelete: (lecture) async {
                                  await classesWithAttendanceController.deleteLecture(
                                    lecture.documentID,
                                  );
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  classesWithAttendanceController.update([
                                    UpdateKeys.updateLectureList,
                                  ]);
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

class ClassesWithAttendanceView extends StatefulWidget {
  const ClassesWithAttendanceView({
    super.key,
    required this.lecture,
    required this.classesWithAttendanceController,
    required this.onRefresh,
    required this.onDelete,
  });

  final ClassesForAttendanceModel lecture;
  final ClassesWithAttendanceController classesWithAttendanceController;
  final void Function() onRefresh;
  final void Function(ClassesForAttendanceModel lecture) onDelete;

  @override
  State<ClassesWithAttendanceView> createState() => _ClassesWithAttendanceViewState();
}

class _ClassesWithAttendanceViewState extends State<ClassesWithAttendanceView> with SingleTickerProviderStateMixin {
  late final SlidableController slideController = SlidableController(this);
  late DateTime startTime;
  late DateTime endTime;
  int differenceInMinutes = 0;
  RxBool deleteLoader = false.obs;

  @override
  void initState() {
    startTime = DateTimeConversion.convertStringToDateTime(widget.lecture.startingTime);
    endTime = DateTimeConversion.convertStringToDateTime(widget.lecture.endingTime);
    differenceInMinutes = endTime.difference(startTime).inMinutes;
    DateTimeConversion.convertMinutesToHours(differenceInMinutes).logOnString('difference => ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.onDelete(widget.lecture);
              await Future.delayed(const Duration(milliseconds: 600));
              widget.onRefresh();
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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.toNamed(
            Routes.lectureDetailsView,
            arguments: widget.lecture,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.height12,
            horizontal: Dimens.width30,
          ),
          margin: EdgeInsets.only(
            bottom: Dimens.height30,
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
                    value: widget.lecture.subject.name,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      dynamic result = await Get.toNamed(
                        Routes.addEditClassesWithAttendanceView,
                        arguments: widget.lecture,
                      );
                      if (result is bool && result == true) {
                        widget.onRefresh();
                      }
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
                    value: widget.lecture.classDetails.name,
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
                        label: widget.lecture.lectureDate,
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
                        label: widget.lecture.startingTime,
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
                        label: widget.lecture.endingTime,
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
                    value: widget.lecture.studentList.length.toString(),
                  ),
                  if (widget.lecture.tasks != null && widget.lecture.tasks!.isNotEmpty)
                    VerticalTitleValueComponent(
                      title: 'No. of Tasks',
                      value: widget.lecture.tasks?.length.toString() ?? '',
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
    this.isCall = false,
    this.titleSize,
    this.valueSize,
  });

  final String title;
  final String value;
  final bool isAtEnd;
  final bool isAtCenter;
  final bool isCall;
  final int? titleSize;
  final int? valueSize;

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
        if (titleSize != null && titleSize! == 8)
          AppTextTheme.textSize8(
            label: title,
            color: AppColors.black.withAlpha(
              (255 * 0.6).toInt(),
            ),
          )
        else if (titleSize != null && titleSize! == 9)
          AppTextTheme.textSize9(
            label: title,
            color: AppColors.black.withAlpha(
              (255 * 0.6).toInt(),
            ),
          )
        else if (titleSize != null && titleSize! == 10)
          AppTextTheme.textSize10(
            label: title,
            color: AppColors.black.withAlpha(
              (255 * 0.6).toInt(),
            ),
          )
        else if (titleSize != null && titleSize! == 11)
          AppTextTheme.textSize11(
            label: title,
            color: AppColors.black.withAlpha(
              (255 * 0.6).toInt(),
            ),
          )
        else
          AppTextTheme.textSize12(
            label: title,
            color: AppColors.black.withAlpha(
              (255 * 0.6).toInt(),
            ),
          ),
        SizedBox(height: Dimens.height4),
        Row(
          children: [
            if (valueSize != null && valueSize! == 10)
              AppTextTheme.textSize10(
                label: value,
                color: AppColors.black,
              )
            else if (valueSize != null && valueSize! == 11)
              AppTextTheme.textSize11(
                label: value,
                color: AppColors.black,
              )
            else if (valueSize != null && valueSize! == 12)
              AppTextTheme.textSize12(
                label: value,
                color: AppColors.black,
              )
            else if (valueSize != null && valueSize! == 13)
              AppTextTheme.textSize13(
                label: value,
                color: AppColors.black,
              )
            else if (valueSize != null && valueSize! == 14)
              AppTextTheme.textSize14(
                label: value,
                color: AppColors.black,
              )
            else if (valueSize != null && valueSize! == 15)
              AppTextTheme.textSize15(
                label: value,
                color: AppColors.black,
              )
            else
              AppTextTheme.textSize16(
                label: value,
                color: AppColors.black,
              ),
            if (isCall) ...[
              SizedBox(width: Dimens.width8),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  Uri url = Uri.parse('tel:$value');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw "Could not launch $url";
                  }
                  url.toString().logOnString('url');
                },
                child: SvgPicture.asset(
                  AssetsPaths.callOutSVG,
                  width: Dimens.width30,
                  height: Dimens.height30,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ],
        )
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
