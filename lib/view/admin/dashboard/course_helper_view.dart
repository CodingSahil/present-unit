import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/course/course_model.dart';

class CourseDetailsCard extends StatefulWidget {
  const CourseDetailsCard({
    super.key,
    required this.courseController,
    required this.course,
    required this.onRefresh,
  });

  final CourseController courseController;
  final Course course;
  final Future<void> Function() onRefresh;

  @override
  State<CourseDetailsCard> createState() => _CourseDetailsCardState();
}

class _CourseDetailsCardState extends State<CourseDetailsCard>
    with SingleTickerProviderStateMixin {
  RxBool deleteLoader = false.obs;
  late final controller = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        openThreshold: 0.1,
        closeThreshold: 0.1,
        children: [
          SlidableAction(
            onPressed: (context) async {
              deleteLoader.value = true;
              await widget.courseController.deleteData(
                course: widget.course,
              );
              widget.courseController.update([
                UpdateKeys.updateCourses,
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
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: () async {
          //     deleteLoader.value = true;
          //     await widget.courseController.deleteData(
          //       course: widget.course,
          //     );
          //     widget.courseController.update([
          //       UpdateKeys.updateCourses,
          //     ]);
          //     widget.onRefresh();
          //     deleteLoader.value = false;
          //     controller.close();
          //   },
          //   child: Obx(
          //     () => deleteLoader.value
          //         ? SizedBox(
          //             height: Dimens.height20,
          //             width: Dimens.width20,
          //             child: Center(
          //               child: Loader(
          //                 color: AppColors.red,
          //               ),
          //             ),
          //           )
          //         : Icon(
          //             Icons.delete,
          //             color: AppColors.red,
          //             size: Dimens.height32,
          //           ),
          //   ),
          // ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.width18,
          vertical: Dimens.height10,
        ),
        padding: EdgeInsets.symmetric(
          vertical: Dimens.height12,
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
                  AppTextTheme.textSize17(
                    label: widget.course.name,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Dimens.height4),
                  AppTextTheme.textSize12(
                    label:
                        'Duration : ${widget.course.duration} ${widget.course.duration >= 2 ? 'Years' : 'Year'}',
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
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
            // AppTextTheme.textSize8(
            //   label: 'Swipe right to Delete',
            //   fontWeight: FontWeight.w600,
            //   color: AppColors.black.withAlpha(
            //     (255 * 0.25).toInt(),
            //   ),
            // ),
            //   ],
            // ),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () async {
            //     setState(() {
            //       deleteLoader = true;
            //     });
            //     await widget.courseController.deleteData(
            //       course: widget.course,
            //     );
            //     widget.courseController.update([
            //       UpdateKeys.updateCourses,
            //     ]);
            //     widget.onRefresh();
            //     setState(() {
            //       deleteLoader = false;
            //     });
            //   },
            //   child: deleteLoader
            //       ? SizedBox(
            //           height: Dimens.height20,
            //           width: Dimens.width20,
            //           child: Center(
            //             child: Loader(
            //               color: AppColors.red,
            //             ),
            //           ),
            //         )
            //       : Icon(
            //           Icons.delete,
            //           color: AppColors.red,
            //           size: Dimens.height32,
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}
