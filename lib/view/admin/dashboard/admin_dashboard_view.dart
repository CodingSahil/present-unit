import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/admin_enum.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/view/admin/dashboard/admin_dashboard_helper_view.dart';
import 'package:present_unit/view/admin/dashboard/course_helper_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  late CourseController courseController;
  AdminBottomNavigationBarEnums selectTab = AdminBottomNavigationBarEnums.home;

  @override
  void initState() {
    super.initState();

    courseController = Get.find<CourseController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await courseController.getListOfCourse(
          context: context,
        );
      },
    );
  }

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

  String iconForBottomNavigationBarEnums({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return AssetsPaths.homeSVG;
      case AdminBottomNavigationBarEnums.course:
        return AssetsPaths.courseSVG;
      case AdminBottomNavigationBarEnums.classList:
        return AssetsPaths.homeSVG;
      case AdminBottomNavigationBarEnums.faculty:
        return AssetsPaths.homeSVG;
      case AdminBottomNavigationBarEnums.subject:
        return AssetsPaths.homeSVG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: viewForSelectedTab(
        bottomNavigationBarEnums: selectTab,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(
          bottom: isIOS ? Dimens.height50 : 0,
        ),
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 0.08,
          maxHeight: MediaQuery.sizeOf(context).height * 0.1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            iconAndTitleHelper(
              bottomNavigationBarEnums: AdminBottomNavigationBarEnums.home,
            ),
            iconAndTitleHelper(
              bottomNavigationBarEnums: AdminBottomNavigationBarEnums.course,
            ),
            iconAndTitleHelper(
              bottomNavigationBarEnums: AdminBottomNavigationBarEnums.faculty,
            ),
          ],
        ),
      ),
    );
  }

  Widget iconAndTitleHelper({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectTab = bottomNavigationBarEnums;
        });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            iconForBottomNavigationBarEnums(
              bottomNavigationBarEnums: bottomNavigationBarEnums,
            ),
            height: Dimens.height40,
            width: Dimens.width40,
            colorFilter: ColorFilter.mode(
              selectTab == bottomNavigationBarEnums
                  ? AppColors.primaryColor
                  : AppColors.unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          AppTextTheme.textSize14(
            label: titleForBottomNavigationBarEnums(
              bottomNavigationBarEnums: bottomNavigationBarEnums,
            ),
            color: selectTab == bottomNavigationBarEnums
                ? AppColors.primaryColor
                : AppColors.unselectedColor,
          ),
        ],
      ),
    );
  }

  Widget viewForSelectedTab({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return AdminDashboardHelperView(
          selectTab: bottomNavigationBarEnums,
        );

      case AdminBottomNavigationBarEnums.course:
        return CourseHelperView(
          courseList: courseController.courseList,
          isAppBarRequire: true,
          onRefresh: () async {
            await courseController.getListOfCourse(
              context: context,
            );
            setState(() {});
          },
        );

      default:
        return AdminDashboardHelperView(
          selectTab: bottomNavigationBarEnums,
        );
    }
  }
}
