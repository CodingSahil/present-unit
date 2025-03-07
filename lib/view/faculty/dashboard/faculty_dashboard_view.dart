import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:present_unit/helper-widgets/bottom_nav_bar.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/faculty_enum.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/view/faculty/assignment/assignment_list_view.dart';
import 'package:present_unit/view/faculty/classes/class_list_view.dart';
import 'package:present_unit/view/faculty/dashboard/faculty_dashboard_subview.dart';

class FacultyDashboardView extends StatefulWidget {
  const FacultyDashboardView({super.key});

  @override
  State<FacultyDashboardView> createState() => _FacultyDashboardViewState();
}

class _FacultyDashboardViewState extends State<FacultyDashboardView> {
  /// bottom navigation
  int selectedIndex = 0;
  FacultyUserModules selectTab = FacultyUserModules.home;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: viewForSelectedTab(
        bottomNavigationBarEnums: selectTab,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        children: [
          iconAndTitleHelper(bottomNavigationBarEnums: FacultyUserModules.home, numberOfTab: 3),
          iconAndTitleHelper(bottomNavigationBarEnums: FacultyUserModules.classes, numberOfTab: 3),
          iconAndTitleHelper(bottomNavigationBarEnums: FacultyUserModules.assignment, numberOfTab: 3),
        ],
      ),
    );
  }

  Widget viewForSelectedTab({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    // List<int> studentList = classListController.classList
    //     .map(
    //       (e) => e.studentList?.length ?? 0,
    // )
    //     .toList();
    // num totalStudents = studentList.isNotEmpty
    //     ? num.parse(
    //   studentList
    //       .reduce(
    //         (value, element) => value + element,
    //   )
    //       .toString(),
    // )
    //     : 0;
    // num totalCourses = courseController.courseList.length;
    // num totalFaculty = facultyController.facultyList.length;
    // num totalSubject = subjectController.subjectList.length;
    // num totalClass = classListController.classList.length;

    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return const FacultyDashboardSubview();

      case FacultyUserModules.classes:
        return const ClassListForAttendanceView();

      case FacultyUserModules.assignment:
        return const AssignmentListView();
    }
  }

  Widget iconAndTitleHelper({
    required FacultyUserModules bottomNavigationBarEnums,
    required int numberOfTab,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / numberOfTab,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            selectTab = bottomNavigationBarEnums;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.height16,
            horizontal: Dimens.width24,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                iconForBottomNavigationBarEnums(
                  bottomNavigationBarEnums: bottomNavigationBarEnums,
                ),
                height: Dimens.height40,
                width: Dimens.width40,
                colorFilter: ColorFilter.mode(
                  selectTab == bottomNavigationBarEnums ? AppColors.primaryColor : AppColors.unselectedColor,
                  BlendMode.srcIn,
                ),
              ),
              AppTextTheme.textSize14(
                label: titleForBottomNavigationBarEnums(
                  bottomNavigationBarEnums: bottomNavigationBarEnums,
                ),
                color: selectTab == bottomNavigationBarEnums ? AppColors.primaryColor : AppColors.unselectedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String iconForBottomNavigationBarEnums({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return AssetsPaths.homeSVG;
      case FacultyUserModules.classes:
        return AssetsPaths.classesSVG;
      case FacultyUserModules.assignment:
        return AssetsPaths.assignmentSVG;
    }
  }

  String titleForBottomNavigationBarEnums({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return 'Home';
      case FacultyUserModules.classes:
        return 'Class';
      case FacultyUserModules.assignment:
        return 'Assignment';
    }
  }
}
