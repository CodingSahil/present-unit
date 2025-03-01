import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/dashboard/course_helper_view.dart';

class CourseView extends StatefulWidget {
  const CourseView({
    super.key,
    this.isInDashboard = false,
  });

  final bool isInDashboard;

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  late CourseController courseController;

  @override
  void initState() {
    super.initState();
    courseController = Get.find<CourseController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Course List',
        isBack: !widget.isInDashboard,
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditCourse);
          if (result is bool && result) {
            await courseController.getListOfCourse();
            setState(() {});
          }
        },
      ),
      body: GetBuilder<CourseController>(
        id: UpdateKeys.updateCourses,
        builder: (CourseController controller) {
          return courseController.courseList.isNotEmpty
              ? ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.width8,
                    vertical: Dimens.height24,
                  ),
                  children: courseController.courseList.map(
                    (course) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        // onTap: () async {
                        //   CourseNavigation courseNavigation =
                        //       CourseNavigation(
                        //     documentID: course.documentID,
                        //     id: course.id,
                        //     name: course.name,
                        //     duration: course.duration.toString(),
                        //     admin: course.admin,
                        //   );
                        //
                        //   var result = await Get.toNamed(
                        //     Routes.addEditCourse,
                        //     arguments: courseNavigation,
                        //   );
                        //   if (result is bool && result) {
                        //     await widget.onRefresh();
                        //   }
                        // },
                        child: CourseDetailsCard(
                          courseController: courseController,
                          course: course,
                          onRefresh: () async {
                            await courseController.getListOfCourse();
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ).toList(),
                )
              : Center(
                  child: AppTextTheme.textSize16(
                    label: LabelStrings.noData,
                  ),
                );
        },
      ),
    );
  }
}
