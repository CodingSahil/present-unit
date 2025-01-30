import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/faculty_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/routes/routes.dart';

class FacultyHelperView extends StatefulWidget {
  const FacultyHelperView({
    super.key,
    required this.facultyController,
    required this.isAppBarRequire,
    required this.onRefresh,
  });

  final FacultyController facultyController;
  final bool isAppBarRequire;
  final Future<void> Function() onRefresh;

  @override
  State<FacultyHelperView> createState() => _FacultyHelperViewState();
}

class _FacultyHelperViewState extends State<FacultyHelperView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FacultyController>(
      id: UpdateKeys.updateFaculty,
      builder: (FacultyController controller) => Column(
        children: [
          if (widget.isAppBarRequire)
            CommonAppBar(
              label: LabelStrings.faculty,
              isBack: false,
              onTap: () async {
                var result = await Get.toNamed(Routes.addEditFaculty);
                if (result is bool && result) {
                  await widget.onRefresh();
                }
              },
            ),
          Expanded(
            child: widget.facultyController.facultyList.isNotEmpty
                ? ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.width8,
                      vertical: Dimens.height24,
                    ),
                    children: widget.facultyController.facultyList.map(
                      (faculty) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            FacultyNavigation facultyNavigation =
                                FacultyNavigation(
                              documentID: faculty.documentID,
                              id: faculty.id,
                              name: faculty.name,
                              email: faculty.email,
                              mobileNumber: faculty.mobileNumber,
                              password: faculty.password,
                              admin: faculty.admin != null
                                  ? faculty.admin!
                                  : Admin.empty(),
                              course: faculty.courseList != null &&
                                      faculty.courseList!.isNotEmpty
                                  ? faculty.courseList!
                                  : [],
                              subject: faculty.subjectList != null &&
                                      faculty.subjectList!.isNotEmpty
                                  ? faculty.subjectList!
                                  : [],
                            );

                            var result = await Get.toNamed(
                              Routes.addEditFaculty,
                              arguments: facultyNavigation,
                            );
                            if (result is bool && result) {
                              await widget.onRefresh();
                            }
                          },
                          child: FacultyDetailsCard(
                            facultyController: widget.facultyController,
                            faculty: faculty,
                            onRefresh: widget.onRefresh,
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
    );
  }
}

class FacultyDetailsCard extends StatefulWidget {
  const FacultyDetailsCard({
    super.key,
    required this.facultyController,
    required this.faculty,
    required this.onRefresh,
  });

  final FacultyController facultyController;
  final Faculty faculty;
  final Future<void> Function() onRefresh;

  @override
  State<FacultyDetailsCard> createState() => _FacultyDetailsCardState();
}

class _FacultyDetailsCardState extends State<FacultyDetailsCard> {
  bool deleteLoader = false;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextTheme.textSize18(
                      label: widget.faculty.name,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize14(
                      label: widget.faculty.email,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize14(
                      label: widget.faculty.mobileNumber,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  setState(() {
                    deleteLoader = true;
                  });
                  await widget.facultyController.deleteFacultyData(
                    faculty: widget.faculty,
                  );
                  widget.facultyController.update([
                    UpdateKeys.updateFaculty,
                  ]);
                  setState(() {
                    deleteLoader = false;
                  });
                  widget.onRefresh();
                },
                child: deleteLoader
                    ? SizedBox(
                        height: Dimens.height20,
                        width: Dimens.width20,
                        child: Center(
                          child: Loader(
                            color: AppColors.red,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.delete,
                        color: AppColors.red,
                        size: Dimens.height32,
                      ),
              ),
            ],
          ),
          SizedBox(height: Dimens.height18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.faculty.courseList != null &&
                  widget.faculty.courseList!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextTheme.textSize14(
                      label: 'Courses',
                      color: AppColors.black.withAlpha(
                        (255 * 0.3).toInt(),
                      ),
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize14(
                      label: widget.faculty.courseList!
                          .map(
                            (e) => e.name.trim(),
                          )
                          .join('\n'),
                      maxLines: widget.faculty.courseList!.length,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              if (widget.faculty.subjectList != null &&
                  widget.faculty.subjectList!.isNotEmpty)
                Column(
                  crossAxisAlignment: widget.faculty.courseList != null &&
                          widget.faculty.courseList!.isNotEmpty
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    AppTextTheme.textSize14(
                      label: 'Subjects',
                      color: AppColors.black.withAlpha(
                        (255 * 0.3).toInt(),
                      ),
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize14(
                      label: widget.faculty.subjectList!
                          .map(
                            (e) => e.name.trim(),
                          )
                          .join('\n'),
                      maxLines: widget.faculty.subjectList!.length,
                      textAlign: widget.faculty.courseList != null &&
                              widget.faculty.courseList!.isNotEmpty
                          ? TextAlign.end
                          : TextAlign.start,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
