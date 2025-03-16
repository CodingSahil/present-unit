import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/faculty/assignment_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/assignment/assignment_model.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/faculty/classes/lecture_list_view.dart';

class AssignmentListView extends StatefulWidget {
  const AssignmentListView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<AssignmentListView> createState() => _AssignmentListViewState();
}

class _AssignmentListViewState extends State<AssignmentListView> {
  late final AssignmentController assignmentController;

  @override
  void initState() {
    assignmentController = Get.find<AssignmentController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await assignmentController.getAssignmentList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Assignment List',
        isBack: widget.arguments != null && widget.arguments is bool && (widget.arguments is bool) == true,
        onTap: () async {
          dynamic result = await Get.toNamed(Routes.addEditAssignmentView);
          if (result is bool && result == true) {
            await assignmentController.getAssignmentList();
            await Future.delayed(const Duration(milliseconds: 500));
            assignmentController.update([UpdateKeys.updateAssignmentList]);
          }
        },
      ),
      body: Obx(
        () => assignmentController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : GetBuilder<AssignmentController>(
                id: UpdateKeys.updateAssignmentList,
                builder: (controller) => ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.height24,
                    horizontal: Dimens.width30,
                  ),
                  hitTestBehavior: HitTestBehavior.translucent,
                  children: controller.assignmentList
                      .map(
                        (assignment) => AssignmentDetailsCard(
                          assignment: assignment,
                          assignmentController: assignmentController,
                          onRefresh: () {},
                          onDelete: (assignment) {},
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
    );
  }
}

class AssignmentDetailsCard extends StatefulWidget {
  const AssignmentDetailsCard({
    super.key,
    required this.assignment,
    required this.assignmentController,
    required this.onRefresh,
    required this.onDelete,
  });

  final AssignmentModel assignment;
  final AssignmentController assignmentController;
  final void Function() onRefresh;
  final void Function(AssignmentModel assignment) onDelete;

  @override
  State<AssignmentDetailsCard> createState() => _AssignmentDetailsCardState();
}

class _AssignmentDetailsCardState extends State<AssignmentDetailsCard> with SingleTickerProviderStateMixin {
  late final SlidableController slideController = SlidableController(this);

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
              widget.onDelete(widget.assignment);
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
          // Get.toNamed(
          //   Routes.lectureDetailsView,
          //   arguments: widget.lecture,
          // );
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
                    value: widget.assignment.subject.name,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      dynamic result = await Get.toNamed(
                        Routes.addEditAssignmentView,
                        arguments: widget.assignment,
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
                    value: widget.assignment.classListModel.name,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTextTheme.textSize12(
                        label: 'Submission Date',
                        color: AppColors.black.withAlpha(
                          (255 * 0.6).toInt(),
                        ),
                      ),
                      SizedBox(width: Dimens.width8),
                      AppTextTheme.textSize16(
                        label: widget.assignment.submissionDate,
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
                    value: widget.assignment.studentList.length.toString(),
                  ),
                  VerticalTitleValueComponent(
                    title: 'Assignment Type',
                    value: widget.assignment.assignmentType[0].toUpperCase() + widget.assignment.assignmentType.substring(1).toLowerCase(),
                    isAtEnd: true,
                  ),
                ],
              ),
              SizedBox(height: Dimens.height6),
              Divider(
                height: 1,
                thickness: 0.5,
                color: AppColors.black.withAlpha((255 * 0.5).toInt()),
              ),
              SizedBox(height: Dimens.height6),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.toNamed(
                    Routes.pdfView,
                    arguments: widget.assignment.assignmentURL,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTextTheme.textSize14(
                      label: 'View Assignment',
                      color: AppColors.black,
                    ),
                    SizedBox(width: Dimens.width12),
                    SvgPicture.asset(
                      AssetsPaths.swipeRightSVG,
                      height: Dimens.height32,
                      width: Dimens.width40,
                      colorFilter: ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.height6),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentDetailsReadOnlyCard extends StatelessWidget {
  const AssignmentDetailsReadOnlyCard({
    super.key,
    required this.assignmentModel,
  });

  final AssignmentModel assignmentModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalTitleValueComponent(
                title: 'Subject',
                value: assignmentModel.subject.name,
              ),
              AppTextTheme.textSize15(
                label: '#${assignmentModel.id}',
                color: AppColors.black,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VerticalTitleValueComponent(
                title: 'Class',
                value: assignmentModel.classListModel.name,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextTheme.textSize12(
                    label: 'Submission Date',
                    color: AppColors.black.withAlpha(
                      (255 * 0.6).toInt(),
                    ),
                  ),
                  SizedBox(width: Dimens.width8),
                  AppTextTheme.textSize16(
                    label: assignmentModel.submissionDate,
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
                value: assignmentModel.studentList.length.toString(),
              ),
              VerticalTitleValueComponent(
                title: 'Assignment Type',
                value: assignmentModel.assignmentType[0].toUpperCase() + assignmentModel.assignmentType.substring(1).toLowerCase(),
                isAtEnd: true,
              ),
            ],
          ),
          SizedBox(height: Dimens.height6),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.black.withAlpha((255 * 0.5).toInt()),
          ),
          SizedBox(height: Dimens.height6),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed(
                Routes.pdfView,
                arguments: assignmentModel.assignmentURL,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTextTheme.textSize14(
                  label: 'View Assignment',
                  color: AppColors.black,
                ),
                SizedBox(width: Dimens.width12),
                SvgPicture.asset(
                  AssetsPaths.swipeRightSVG,
                  height: Dimens.height32,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.height6),
        ],
      ),
    );
  }
}
