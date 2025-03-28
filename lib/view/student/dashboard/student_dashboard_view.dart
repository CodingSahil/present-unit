import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/faculty_enum.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class StudentDashboardView extends StatefulWidget {
  const StudentDashboardView({super.key});

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  int selectedIndex = 0;
  FacultyUserModules selectTab = FacultyUserModules.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppTextTheme.textSize16(
          label: 'Dashboard',
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.bottomNavigationBarColor,
        indicatorColor: AppColors.primaryColor,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() {
          selectedIndex = value;
          if (value == 0) {
            selectTab = FacultyUserModules.home;
          }
          if (value == 1) {
            selectTab = FacultyUserModules.classes;
          }
          if (value == 2) {
            selectTab = FacultyUserModules.assignment;
          }
        }),
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              AssetsPaths.homeSVG,
              height: Dimens.height40,
              width: Dimens.width40,
              colorFilter: ColorFilter.mode(
                AppColors.unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              AssetsPaths.homeSVG,
              height: Dimens.height40,
              width: Dimens.width40,
              colorFilter: ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              AssetsPaths.classesSVG,
              height: Dimens.height40,
              width: Dimens.width40,
              colorFilter: ColorFilter.mode(
                AppColors.unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              AssetsPaths.classesSVG,
              height: Dimens.height40,
              width: Dimens.width40,
              colorFilter: ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Lecture',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              AssetsPaths.assignmentSVG,
              height: Dimens.height40,
              width: Dimens.width40,
              colorFilter: ColorFilter.mode(
                AppColors.unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              AssetsPaths.assignmentSVG,
              height: Dimens.height40,
              width: Dimens.width40,
              colorFilter: ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Assignment',
          ),
        ],
      ),
    );
  }
}
