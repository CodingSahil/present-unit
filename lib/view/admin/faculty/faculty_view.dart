import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/faculty_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/dashboard/faculty_helper_view.dart';

class FacultyView extends StatefulWidget {
  const FacultyView({
    super.key,
    this.isInDashboard = false,
  });

  final bool isInDashboard;

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
        isBack: !widget.isInDashboard,
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditFaculty);
          if (result is bool && result) {
            await facultyController.getListOfFaculty();
            setState(() {});
          }
        },
      ),
      body: GetBuilder<FacultyController>(
        id: UpdateKeys.updateFaculty,
        builder: (FacultyController controller) => Column(
          children: [
            Expanded(
              child: facultyController.facultyList.isNotEmpty
                  ? ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.width8,
                        vertical: Dimens.height24,
                      ),
                      children: facultyController.facultyList.map(
                        (faculty) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              FacultyNavigation facultyNavigation = FacultyNavigation(
                                documentID: faculty.documentID,
                                id: faculty.id,
                                name: faculty.name,
                                email: faculty.email,
                                mobileNumber: faculty.mobileNumber,
                                password: faculty.password,
                                admin: faculty.admin != null ? faculty.admin! : Admin.empty(),
                                course: faculty.courseList != null && faculty.courseList!.isNotEmpty ? faculty.courseList! : [],
                                subject: faculty.subjectList != null && faculty.subjectList!.isNotEmpty ? faculty.subjectList! : [],
                              );

                              var result = await Get.toNamed(
                                Routes.addEditFaculty,
                                arguments: facultyNavigation,
                              );
                              if (result is bool && result) {
                                await facultyController.getListOfFaculty();
                                setState(() {});
                              }
                            },
                            child: FacultyDetailsCard(
                              facultyController: facultyController,
                              faculty: faculty,
                              onRefresh: () async {
                                await facultyController.getListOfFaculty();
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
