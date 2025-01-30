import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/faculty_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/dashboard/faculty_helper_view.dart';

class FacultyView extends StatefulWidget {
  const FacultyView({super.key});

  @override
  State<FacultyView> createState() => _FacultyViewState();
}

class _FacultyViewState extends State<FacultyView> {
  late FacultyController facultyController;

  @override
  void initState() {
    super.initState();
    facultyController = Get.find<FacultyController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Faculty List',
        isBack: true,
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditFaculty);
          if (result is bool && result) {
            await facultyController.getListOfFaculty();
            setState(() {});
          }
        },
      ),
      body: FacultyHelperView(
        facultyController: facultyController,
        isAppBarRequire: false,
        onRefresh: () async {
          await facultyController.getListOfFaculty();
          setState(() {});
        },
      ),
    );
  }
}
