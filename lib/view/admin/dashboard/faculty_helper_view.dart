import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/faculty_controller.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';

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

class _FacultyDetailsCardState extends State<FacultyDetailsCard>
    with SingleTickerProviderStateMixin {
  RxBool deleteLoader = false.obs;
  late final controller = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        openThreshold: 0.1,
        closeThreshold: 0.1,
        children: [
          SlidableAction(
            onPressed: (context) async {
              deleteLoader.value = true;
              await widget.facultyController.deleteFacultyData(
                faculty: widget.faculty,
              );
              widget.facultyController.update([
                UpdateKeys.updateFaculty,
              ]);
              widget.onRefresh();
              deleteLoader.value = false;
              controller.close();
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
      ),
    );
  }
}
