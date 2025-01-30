import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/dashboard/course_helper_view.dart';

class CourseView extends StatefulWidget {
  const CourseView({super.key});

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
        isBack: true,
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditCourse);
          if (result is bool && result) {
            await courseController.getListOfCourse();
            setState(() {});
          }
        },
      ),
      body: CourseHelperView(
        courseController: courseController,
        isAppBarRequire: false,
        onRefresh: () async {
          await courseController.getListOfCourse();
          setState(() {});
        },
      ),
    );
  }
}
