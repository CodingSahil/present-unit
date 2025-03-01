import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/class_list_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/routes/routes.dart';

class ClassListView extends StatefulWidget {
  const ClassListView({super.key});

  @override
  State<ClassListView> createState() => _ClassListViewState();
}

class _ClassListViewState extends State<ClassListView> {
  late ClassListController classListController;

  @override
  void initState() {
    super.initState();
    classListController = Get.find<ClassListController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await classListController.getListOfClassList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'Class List',
        onTap: () async {
          var result = await Get.toNamed(Routes.addEditClassList);
          if (result is bool && result) {
            await classListController.getListOfClassList();
            classListController.update([UpdateKeys.updateSubject]);
          }
        },
      ),
      body: GetBuilder<ClassListController>(
        id: UpdateKeys.updateSubject,
        builder: (ClassListController controller) => classListController.classList.isNotEmpty
            ? ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.width8,
                  vertical: Dimens.height24,
                ),
                children: classListController.classList
                    .map(
                      (classList) => ClassDetailsView(
                        classListController: classListController,
                        classList: classList,
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: AppTextTheme.textSize16(
                  label: LabelStrings.noData,
                ),
              ),
      ),
    );
  }
}

class ClassDetailsView extends StatefulWidget {
  const ClassDetailsView({
    super.key,
    required this.classListController,
    required this.classList,
  });

  final ClassListController classListController;
  final ClassListModel classList;

  @override
  State<ClassDetailsView> createState() => _ClassDetailsViewState();
}

class _ClassDetailsViewState extends State<ClassDetailsView> with SingleTickerProviderStateMixin {
  late final slideController = SlidableController(this);
  late ClassListModel classList;

  @override
  void initState() {
    classList = widget.classList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slideController,
      endActionPane: ActionPane(motion: const ScrollMotion(), extentRatio: 0.4, openThreshold: 0.1, closeThreshold: 0.1, children: [
        SlidableAction(
          onPressed: (context) async {
            // setState(() {
            //   deleteLoader = true;
            // });
            await widget.classListController.deleteClassListObject(
              documentName: classList.documentID,
            );
            // setState(() {
            //   deleteLoader = false;
            // });
            widget.classListController.update([
              UpdateKeys.updateSubject,
            ]);
            slideController.close();
          },
          icon: Icons.delete,
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          borderRadius: BorderRadius.circular(
            Dimens.radius15,
          ),
        )
      ]),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          ClassListModel classListModel = ClassListModel(
            documentID: classList.documentID,
            id: classList.id,
            name: classList.name,
            division: classList.division,
            courseBatchYear: classList.courseBatchYear,
            studentList: classList.studentList,
            college: classList.college,
            course: classList.course != null ? classList.course! : Course.empty(),
            admin: classList.admin != null ? classList.admin! : Admin.empty(),
          );

          var result = await Get.toNamed(
            Routes.addEditClassList,
            arguments: classListModel,
          );
          if (result is bool && result) {
            await widget.classListController.getListOfClassList();
            widget.classListController.update([UpdateKeys.updateSubject]);
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
                      label: classList.name,
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize12(
                      label: 'Division : ${classList.division}',
                      color: AppColors.black,
                    ),
                    if (classList.course != null) ...[
                      SizedBox(height: Dimens.height4),
                      AppTextTheme.textSize12(
                        label: 'Course : ${classList.course!.name}',
                        color: AppColors.black,
                      ),
                    ],
                    SizedBox(height: Dimens.height4),
                    AppTextTheme.textSize12(
                      label: 'No. of Students : ${classList.studentList?.length ?? 0}',
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
