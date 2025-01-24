import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/routes/routes.dart';

class CourseHelperView extends StatefulWidget {
  const CourseHelperView({
    super.key,
    required this.courseController,
    required this.isAppBarRequire,
    required this.onRefresh,
  });

  final CourseController courseController;
  final bool isAppBarRequire;
  final Future<void> Function() onRefresh;

  @override
  State<CourseHelperView> createState() => _CourseHelperViewState();
}

class _CourseHelperViewState extends State<CourseHelperView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(
      id: UpdateKeys.updateCourses,
      builder: (CourseController controller) {
        return Column(
          children: [
            if (widget.isAppBarRequire)
              CommonAppBar(
                label: LabelStrings.course,
                isBack: false,
                onTap: () async {
                  var result = await Get.toNamed(Routes.addEditCourse);
                  if (result is bool && result) {
                    await widget.onRefresh();
                  }
                },
              ),
            Expanded(
              child: widget.courseController.courseList.isNotEmpty
                  ? ListView(
                      children: widget.courseController.courseList.map(
                        (course) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              CourseNavigation courseNavigation =
                                  CourseNavigation(
                                documentID: course.documentID,
                                id: course.id,
                                name: course.name,
                                duration: course.duration.toString(),
                                admin: course.admin,
                              );

                              var result = await Get.toNamed(
                                Routes.addEditCourse,
                                arguments: courseNavigation,
                              );
                              if (result is bool && result) {
                                await widget.onRefresh();
                              }
                            },
                            child: CourseDetailsCard(
                              courseController: widget.courseController,
                              course: course,
                            ),
                          );
                        },
                      ).toList(),
                    )
                  : Center(
                      child: AppTextTheme.textSize16(
                        label: LabelStrings.noData,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class CourseDetailsCard extends StatelessWidget {
  const CourseDetailsCard({
    super.key,
    required this.courseController,
    required this.course,
  });

  final CourseController courseController;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimens.width18,
        right: Dimens.width18,
        bottom: Dimens.height8,
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.height8,
        horizontal: Dimens.width18,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.black.withAlpha(
            (255 * 0.1).toInt(),
          ),
        ),
        borderRadius: BorderRadius.circular(
          Dimens.radius15,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTheme.textSize18(
                  label: course.name,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: Dimens.height4),
                AppTextTheme.textSize12(
                  label:
                      '${course.duration} ${course.duration >= 2 ? 'Years' : 'Year'}',
                  color: AppColors.black,
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await courseController.deleteData(
                course: course,
                context: context,
              );
              courseController.update([
                UpdateKeys.updateCourses,
              ]);
            },
            child: Obx(
              () => courseController.deleteLoader.value
                  ? SizedBox(
                      height: Dimens.height24,
                      width: Dimens.width24,
                      child: Loader(
                        color: AppColors.red,
                      ),
                    )
                  : Icon(
                      Icons.delete,
                      color: AppColors.red,
                      size: Dimens.height36,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
