import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/subject_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/routes/routes.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({super.key});

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  late SubjectController subjectController;

  @override
  void initState() {
    super.initState();
    subjectController = Get.find<SubjectController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CommonAppBarPreferred(
        label: 'Subject List',
        isBack: true,
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditSubject);
          if (result is bool && result) {
            await subjectController.getListOfSubject(
              context: context,
            );
            setState(() {});
          }
        },
      ),
      body: subjectController.subjectList.isNotEmpty
          ? ListView(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.height30,
                horizontal: Dimens.width8,
              ),
              children: subjectController.subjectList.map(
                (subject) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      SubjectNavigation subjectNavigation = SubjectNavigation(
                        documentID: subject.documentID,
                        id: subject.id,
                        name: subject.name,
                        credit: subject.credit,
                        semester: subject.semester,
                        subjectCode: subject.subjectCode,
                        college: subject.college,
                        course: subject.course != null
                            ? subject.course!
                            : Course.empty(),
                        admin: subject.admin != null
                            ? subject.admin!
                            : Admin.empty(),
                      );

                      var result = await Get.toNamed(
                        Routes.addEditSubject,
                        arguments: subjectNavigation,
                      );
                      if (result is bool && result) {
                        await subjectController.getListOfSubject(
                          context: context,
                        );
                        setState(() {});
                      }
                    },
                    child: Container(
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
                                  label: subject.name,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: Dimens.height4),
                                AppTextTheme.textSize12(
                                  label: 'Semester ${subject.semester}',
                                  color: AppColors.black,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await subjectController.deleteData(
                                subject: subject,
                                context: context,
                              );
                              setState(() {});
                            },
                            child: Icon(
                              Icons.delete,
                              color: AppColors.red,
                              size: Dimens.height36,
                            ),
                          ),
                        ],
                      ),
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
    );
  }
}
