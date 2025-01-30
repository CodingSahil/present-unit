import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/admin_enum.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/routes/routes.dart';

class AdminDashboardHelperView extends StatefulWidget {
  const AdminDashboardHelperView({
    super.key,
    required this.selectTab,
    required this.admin,
    required this.totalStudents,
    required this.totalCourses,
    required this.totalFaculty,
    required this.totalSubject,
    required this.totalClass,
    required this.onSelectionOfNewTab,
  });

  final AdminBottomNavigationBarEnums selectTab;
  final Admin? admin;
  final num totalStudents;
  final num totalCourses;
  final num totalFaculty;
  final num totalSubject;
  final num totalClass;
  final void Function(AdminBottomNavigationBarEnums passedValue)
      onSelectionOfNewTab;

  @override
  State<AdminDashboardHelperView> createState() =>
      _AdminDashboardHelperViewState();
}

class _AdminDashboardHelperViewState extends State<AdminDashboardHelperView> {
  String titleForBottomNavigationBarEnums({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return LabelStrings.home;
      case AdminBottomNavigationBarEnums.course:
        return LabelStrings.course;
      case AdminBottomNavigationBarEnums.classList:
        return LabelStrings.classList;
      case AdminBottomNavigationBarEnums.faculty:
        return LabelStrings.faculty;
      case AdminBottomNavigationBarEnums.subject:
        return LabelStrings.subject;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: AppTextTheme.textSize16(
            label: 'Welcome ${widget.admin?.name}',
            color: AppColors.white,
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.width22,
                ),
                child: SvgPicture.asset(
                  AssetsPaths.drawerSVG,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                  height: Dimens.height40,
                  width: Dimens.width40,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimens.height20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.width24,
            ),
            hitTestBehavior: HitTestBehavior.translucent,
            childAspectRatio: 4 / 2,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              CommonDashboardCard(
                title: 'Total Students',
                total: widget.totalStudents.toString(),
                svgPicturePath: AssetsPaths.studentSVG,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.onSelectionOfNewTab(
                    AdminBottomNavigationBarEnums.course,
                  );
                },
                child: CommonDashboardCard(
                  title: 'Total Courses',
                  total: widget.totalCourses.toString(),
                  svgPicturePath: AssetsPaths.courseSVG,
                  svgPictureColor: AppColors.darkGreen,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.onSelectionOfNewTab(
                    AdminBottomNavigationBarEnums.faculty,
                  );
                },
                child: CommonDashboardCard(
                  title: 'Total Faculty',
                  total: widget.totalFaculty.toString(),
                  svgPicturePath: AssetsPaths.facultySVG,
                  svgPictureColor: AppColors.skyBlue,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.toNamed(
                    Routes.subjectView,
                  );
                },
                child: CommonDashboardCard(
                  title: 'Total Subjects',
                  total: widget.totalSubject.toString(),
                  svgPicturePath: AssetsPaths.subjectSVG,
                  svgPictureColor: AppColors.customPurple,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.toNamed(
                    Routes.classListView,
                  );
                },
                child: CommonDashboardCard(
                  title: 'Total Classes',
                  total: widget.totalClass.toString(),
                  svgPicturePath: AssetsPaths.classSVG,
                  svgPictureColor: AppColors.customLogoOrange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommonDashboardCard extends StatelessWidget {
  const CommonDashboardCard({
    super.key,
    required this.title,
    required this.total,
    required this.svgPicturePath,
    this.svgPictureColor,
  });

  final String title;
  final String total;
  final Color? svgPictureColor;
  final String svgPicturePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackgroundForCard,
        borderRadius: BorderRadius.circular(
          Dimens.radius30,
        ),
        border: Border.all(
          color: AppColors.black.withAlpha(
            (255 * 0.05).toInt(),
          ),
          width: 1,
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Dimens.width16,
        vertical: Dimens.height8,
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.height8,
        horizontal: Dimens.width30,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextTheme.textSize10(
                  label: title,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black.withAlpha(
                    (255 * 0.5).toInt(),
                  ),
                ),
                AppTextTheme.textSize20(
                  label: total,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
          Container(
            height: Dimens.height60,
            width: Dimens.width64,
            padding: EdgeInsets.symmetric(
              vertical: Dimens.height10,
              horizontal: Dimens.width10,
            ),
            decoration: BoxDecoration(
              color: svgPictureColor ?? AppColors.primaryColor,
              borderRadius: BorderRadius.circular(
                Dimens.radius10,
              ),
            ),
            child: SvgPicture.asset(
              svgPicturePath,
              colorFilter: ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
