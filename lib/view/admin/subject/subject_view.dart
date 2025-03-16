import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/subject_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/admin/admin_navigation_models.dart';
import 'package:present_unit/models/subject/subject_model.dart';
import 'package:present_unit/routes/routes.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({super.key});

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> with SingleTickerProviderStateMixin {
  late SubjectController subjectController;
  late final slideController = SlidableController(this);
  bool deleteLoader = false;

  @override
  void initState() {
    super.initState();
    subjectController = Get.find<SubjectController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await subjectController.getListOfSubject();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Subject List',
        isBack: true,
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditSubject);
          if (result is bool && result) {
            await subjectController.getListOfSubject();
            await Future.delayed(
              const Duration(milliseconds: 500),
            );
            subjectController.update([UpdateKeys.updateSubject]);
          }
        },
      ),
      body: Obx(() => subjectController.loader.value
          ? Center(
        child: Loader(
          color: AppColors.primaryColor,
        ),
      )
          : GetBuilder<SubjectController>(
        id: UpdateKeys.updateSubject,
        builder: (SubjectController controller) => controller.subjectList.isNotEmpty
            ? ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.width8,
            vertical: Dimens.height24,
          ),
          children: controller.subjectList
              .map(
                (subject) => SubjectDetailCard(
              subjectController: controller,
              subject: subject,
              onRefresh: () async {
                await subjectController.getListOfSubject();
                await Future.delayed(
                  const Duration(seconds: 1),
                );
                subjectController.update([UpdateKeys.updateSubject]);
              },
              onDelete: (subject) async {
                await subjectController.deleteData(
                  subject: subject,
                );
                await Future.delayed(const Duration(milliseconds: 500));
              },
            ),
          )
              .toList(),
        )
            : Center(
          child: AppTextTheme.textSize16(
            label: LabelStrings.noData,
          ),
        ),
      ),),
    );
  }
}

class SubjectDetailCard extends StatefulWidget {
  const SubjectDetailCard({
    super.key,
    required this.subjectController,
    required this.subject,
    required this.onRefresh,
    required this.onDelete,
  });

  final SubjectController subjectController;
  final Subject subject;
  final void Function() onRefresh;
  final void Function(Subject subject) onDelete;

  @override
  State<SubjectDetailCard> createState() => _SubjectDetailCardState();
}

class _SubjectDetailCardState extends State<SubjectDetailCard> with SingleTickerProviderStateMixin {
  late final slideController = SlidableController(this);
  late Subject subject;

  @override
  void initState() {
    subject = widget.subject;
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
              log('subject => ${jsonEncode(subject.toJson())}');
              widget.onDelete(subject);
              await Future.delayed(const Duration(seconds: 1));
              widget.onRefresh();
              slideController.close();
            },
            icon: Icons.delete,
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            borderRadius: BorderRadius.circular(
              Dimens.radius15,
            ),
          )
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          SubjectNavigation subjectNavigation = SubjectNavigation(
            documentID: subject.documentID,
            id: subject.id,
            name: subject.name,
            credit: subject.credit,
            semester: subject.semester,
            subjectCode: subject.subjectCode,
            course: subject.course != null ? subject.course! : Course.empty(),
            admin: subject.admin != null ? subject.admin! : Admin.empty(),
          );

          var result = await Get.toNamed(
            Routes.addEditSubject,
            arguments: subjectNavigation,
          );
          if (result is bool && result) {
            widget.onRefresh();
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
                      label: '${subject.subjectCode} - ${subject.name}',
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    if (subject.course != null) ...[
                      SizedBox(height: Dimens.height4),
                      AppTextTheme.textSize12(
                        label: 'Course : ${subject.course!.name}',
                        color: AppColors.black,
                      ),
                    ],
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize12(
                      label: 'Subject Credit : ${subject.credit}',
                      color: AppColors.black,
                    ),
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize12(
                      label: 'Semester : ${subject.semester}',
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                AssetsPaths.swipeRightSVG,
                height: Dimens.height36,
                width: Dimens.width36,
                colorFilter: ColorFilter.mode(
                  AppColors.black.withAlpha(
                    (255 * 0.25).toInt(),
                  ),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
