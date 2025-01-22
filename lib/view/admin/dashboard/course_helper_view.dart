import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/routes/routes.dart';

class CourseHelperView extends StatefulWidget {
  const CourseHelperView({
    super.key,
    required this.courseList,
    required this.isAppBarRequire,
    required this.onRefresh,
  });

  final List<Course> courseList;
  final bool isAppBarRequire;
  final Future<void> Function() onRefresh;

  @override
  State<CourseHelperView> createState() => _CourseHelperViewState();
}

class _CourseHelperViewState extends State<CourseHelperView> {
  @override
  Widget build(BuildContext context) {
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
          child: widget.courseList.isNotEmpty
              ? ListView(
                  children: widget.courseList.map(
                    (course) {
                      return CourseDetailsCard(
                        courseName: course.name,
                        courseDuration:
                            '${course.duration} ${course.duration >= 2 ? 'Years' : 'Year'}',
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
  }
}

class CourseDetailsCard extends StatelessWidget {
  const CourseDetailsCard({
    super.key,
    required this.courseName,
    required this.courseDuration,
  });

  final String courseName;
  final String courseDuration;

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
                  label: courseName,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: Dimens.height4),
                AppTextTheme.textSize12(
                  label: courseDuration,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
          Icon(
            Icons.info_outline,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}
